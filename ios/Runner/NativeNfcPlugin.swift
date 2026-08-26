import CommonCrypto
import CoreNFC
import Flutter
import UIKit

class NativeNfcPlugin: NSObject, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.anycubic.nfc/native", binaryMessenger: registrar.messenger())
        let instance = NativeNfcPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private var session: NFCTagReaderSession?
    private var result: FlutterResult?
    private var pagesToWrite: [[String: Any]]?
    private var isBambuLabMode = false
    private var isOpenPrintTagMode = false
    private var isAutoDetectMode = false
    private var isOpenPrintTagWriteMode = false
    private var openPrintTagDataToWrite: [UInt8]?
    private var bambuBlocksToWrite: [String: [UInt8]]?
    private var sessionStartTime: Date?
    private var tagDetectedTime: Date?
    private var tagDetected = false

    // Retry sur code 202 (iOS 26 « session terminée inopinément »). Best practice :
    // restartPolling ne marche pas sur une session invalidée → recréer une NOUVELLE
    // session, après un délai (éviter le 203 « système occupé »), 1 seule fois.
    private var currentPolling: NFCTagReaderSession.PollingOption = .iso14443
    private var currentAlert = "Maintenez votre téléphone près du tag NFC"
    private var session202Retries = 0
    private let maxSession202Retries = 1

    /// Démarre (ou redémarre) une session NFC en mémorisant sa config pour un
    /// éventuel retry sur code 202. `isNewScan` remet le compteur de retry à zéro.
    private func beginSession(pollingOption: NFCTagReaderSession.PollingOption,
                              alertMessage: String,
                              isNewScan: Bool) {
        if isNewScan { session202Retries = 0 }
        currentPolling = pollingOption
        currentAlert = alertMessage
        session = NFCTagReaderSession(pollingOption: pollingOption, delegate: self)
        session?.alertMessage = alertMessage
        startSessionTracking()
        session?.begin()
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "checkNfcAvailability":
            result(NFCTagReaderSession.readingAvailable)
        case "startReadSession":
            startReadSession(result: result)
        case "stopSession":
            stopSession(result: result)
        case "startWriteSession":
            guard let args = call.arguments as? [String: Any],
                  let pages = args["pages"] as? [[String: Any]] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing pages argument", details: nil))
                return
            }
            startWriteSession(pages: pages, result: result)
        case "readBambuLabTag":
            startBambuLabReadSession(result: result)
        case "readOpenPrintTag":
            startOpenPrintTagReadSession(result: result)
        case "startAutoDetectReadSession":
            // iso14443Only : contourne le bug iOS 26 où le polling combiné
            // [.iso14443, .iso15693] casse la détection ISO 14443 (NTAG)
            let args = call.arguments as? [String: Any]
            let iso14443Only = args?["iso14443Only"] as? Bool ?? false
            startAutoDetectReadSession(iso14443Only: iso14443Only, result: result)
        case "writeBambuLabClone":
            guard let args = call.arguments as? [String: Any],
                  let blocks = args["blocks"] as? [String: [UInt8]] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing blocks argument", details: nil))
                return
            }
            startBambuLabWriteSession(blocks: blocks, result: result)
        case "writeOpenPrintTag":
            guard let args = call.arguments as? [String: Any],
                  let data = args["data"] as? [Int] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing data argument", details: nil))
                return
            }
            startOpenPrintTagWriteSession(data: data.map { UInt8($0 & 0xFF) }, result: result)
        case "readCrealityTag", "writeCrealityTag":
            // MiFare Classic (Crypto1) n'est pas supporté par Apple CoreNFC
            result(FlutterError(
                code: "PLATFORM_NOT_SUPPORTED",
                message: "Les tags Creality CFS utilisent MiFare Classic qui n'est pas supporté par Apple CoreNFC. Cette fonctionnalité est disponible sur Android uniquement.",
                details: nil
            ))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startReadSession(result: @escaping FlutterResult) {
        self.result = result

        beginSession(pollingOption: .iso14443,
                     alertMessage: "Maintenez votre téléphone près du tag NFC",
                     isNewScan: true)
    }

    private func stopSession(result: @escaping FlutterResult) {
        print("🛑 Arrêt de la session NFC demandé")
        if let activeSession = session {
            activeSession.invalidate()
        }
        // Notifier le callback en attente si il y en a un
        if let pendingResult = self.result {
            pendingResult(FlutterError(code: "USER_CANCELLED", message: "Session arrêtée", details: buildSessionDiagnostics()))
        }
        self.result = nil
        self.session = nil
        self.isBambuLabMode = false
        self.isOpenPrintTagMode = false
        self.isAutoDetectMode = false
        self.isOpenPrintTagWriteMode = false
        self.pagesToWrite = nil
        self.bambuBlocksToWrite = nil
        self.openPrintTagDataToWrite = nil
        resetSessionTracking()
        result(true)
    }

    private func startWriteSession(pages: [[String: Any]], result: @escaping FlutterResult) {
        self.result = result
        self.pagesToWrite = pages
        self.isBambuLabMode = false

        beginSession(pollingOption: .iso14443,
                     alertMessage: "Maintenez votre téléphone près du tag NFC pour écriture",
                     isNewScan: true)
    }

    private func startBambuLabReadSession(result: @escaping FlutterResult) {
        self.result = result
        self.isBambuLabMode = true

        beginSession(pollingOption: .iso14443,
                     alertMessage: "Maintenez votre téléphone près du tag NFC",
                     isNewScan: true)
    }

    private func startOpenPrintTagReadSession(result: @escaping FlutterResult) {
        self.result = result
        self.isOpenPrintTagMode = true

        beginSession(pollingOption: [.iso15693],
                     alertMessage: "Maintenez votre téléphone près du tag NFC Prusa",
                     isNewScan: true)
    }

    private func startAutoDetectReadSession(iso14443Only: Bool = false, result: @escaping FlutterResult) {
        self.result = result
        self.isAutoDetectMode = true

        let polling: NFCTagReaderSession.PollingOption =
            iso14443Only ? .iso14443 : [.iso14443, .iso15693]
        beginSession(pollingOption: polling,
                     alertMessage: "Maintenez votre téléphone près du tag NFC",
                     isNewScan: true)
    }

    private func startOpenPrintTagWriteSession(data: [UInt8], result: @escaping FlutterResult) {
        self.result = result
        self.openPrintTagDataToWrite = data
        self.isOpenPrintTagWriteMode = true

        beginSession(pollingOption: [.iso15693],
                     alertMessage: "Maintenez votre téléphone près du tag NFC ISO 15693 vierge",
                     isNewScan: true)
    }

    private func startBambuLabWriteSession(blocks: [String: [UInt8]], result: @escaping FlutterResult) {
        self.result = result
        self.bambuBlocksToWrite = blocks

        beginSession(pollingOption: .iso14443,
                     alertMessage: "Maintenez votre téléphone près de la carte CUID vierge",
                     isNewScan: true)
    }

    private func buildSessionDiagnostics(tagType: String? = nil) -> [String: Any] {
        var details: [String: Any] = [
            "tag_was_detected": tagDetected,
        ]
        if let start = sessionStartTime {
            details["session_duration_ms"] = Int(Date().timeIntervalSince(start) * 1000)
        }
        if let tagType = tagType {
            details["tag_type"] = tagType
        }
        return details
    }

    private func resetSessionTracking() {
        self.sessionStartTime = nil
        self.tagDetectedTime = nil
        self.tagDetected = false
    }

    private func startSessionTracking() {
        self.sessionStartTime = Date()
        self.tagDetectedTime = nil
        self.tagDetected = false
    }
}

extension NativeNfcPlugin: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("📱 Session NFC active")
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        // Ignorer si le résultat a déjà été envoyé (invalidation volontaire après succès)
        guard self.result != nil else {
            print("ℹ️ Session invalidée (ignorée - résultat déjà envoyé): \(error.localizedDescription)")
            return
        }

        let nsError = error as NSError

        // Code 200: Annulation par l'utilisateur
        if nsError.domain == "NFCError" && nsError.code == 200 {
            print("ℹ️ Session annulée par l'utilisateur")
            result?(FlutterError(code: "USER_CANCELLED", message: "Scan annulé par l'utilisateur", details: buildSessionDiagnostics()))
            self.result = nil
            self.isBambuLabMode = false
            self.isOpenPrintTagMode = false
            self.isAutoDetectMode = false
            self.pagesToWrite = nil
            self.bambuBlocksToWrite = nil
            resetSessionTracking()
            return
        }

        // Code 201: Timeout - aucun tag détecté dans le délai
        if nsError.domain == "NFCError" && nsError.code == 201 {
            print("⏱️ Session timeout - aucun tag NFC détecté")
            result?(FlutterError(code: "TAG_NOT_DETECTED", message: "Aucun tag NFC détecté. Le tag est peut-être mort ou incompatible.", details: buildSessionDiagnostics()))
            self.result = nil
            self.isBambuLabMode = false
            self.isOpenPrintTagMode = false
            self.isAutoDetectMode = false
            self.pagesToWrite = nil
            self.bambuBlocksToWrite = nil
            resetSessionTracking()
            return
        }

        // Code 202: Session terminée de façon inattendue (iOS 26+ peut forcer l'arrêt).
        // Best practice : recréer une NOUVELLE session (restartPolling est inopérant
        // sur une session invalidée), après un délai (éviter le 203), 1 seule fois.
        // On préserve le mode (on ne reset pas les flags) pour rescanner à l'identique.
        if nsError.domain == "NFCError" && nsError.code == 202 {
            if session202Retries < maxSession202Retries {
                session202Retries += 1
                print("⚠️ Session 202 → retry \(session202Retries)/\(maxSession202Retries) (nouvelle session)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
                    guard let self = self, self.result != nil else { return }
                    self.beginSession(pollingOption: self.currentPolling,
                                      alertMessage: self.currentAlert,
                                      isNewScan: false)
                }
                return
            }
            print("⚠️ Session NFC interrompue par le système (code 202) — retry épuisé")
            result?(FlutterError(code: "SESSION_TERMINATED", message: "Session NFC interrompue par le système. Réessayez.", details: buildSessionDiagnostics()))
            self.result = nil
            self.isBambuLabMode = false
            self.isOpenPrintTagMode = false
            self.isAutoDetectMode = false
            self.pagesToWrite = nil
            self.bambuBlocksToWrite = nil
            resetSessionTracking()
            return
        }

        // Code 203: Système occupé
        if nsError.domain == "NFCError" && nsError.code == 203 {
            print("⚠️ Système NFC occupé")
            result?(FlutterError(code: "SYSTEM_BUSY", message: "Le lecteur NFC est occupé. Réessayez.", details: buildSessionDiagnostics()))
            self.result = nil
            self.isBambuLabMode = false
            self.isOpenPrintTagMode = false
            self.isAutoDetectMode = false
            self.pagesToWrite = nil
            self.bambuBlocksToWrite = nil
            resetSessionTracking()
            return
        }

        print("❌ Session invalidée: \(error.localizedDescription) (domain: \(nsError.domain), code: \(nsError.code))")
        result?(FlutterError(code: "SESSION_ERROR", message: error.localizedDescription, details: buildSessionDiagnostics()))
        self.result = nil
        resetSessionTracking()
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        self.tagDetected = true
        self.tagDetectedTime = Date()

        guard let tag = tags.first else {
            result?(FlutterError(code: "NO_TAG", message: "Aucun tag détecté", details: buildSessionDiagnostics()))
            return
        }

        // Détecter les tags ISO 15693 (NFC-V) - ex: Prusa OpenPrintTag
        if case let .iso15693(iso15693Tag) = tag {
            print("📡 Tag ISO 15693 (NFC-V) détecté - identifier: \(iso15693Tag.identifier.map { String(format: "%02x", $0) }.joined(separator: ":"))")

            // Si on est en mode écriture OpenPrintTag
            if self.isOpenPrintTagWriteMode, let dataToWrite = self.openPrintTagDataToWrite {
                session.connect(to: tag) { error in
                    if let error = error {
                        print("❌ Erreur connexion ISO 15693: \(error.localizedDescription)")
                        session.invalidate(errorMessage: "Erreur de connexion au tag")
                        self.result?(FlutterError(code: "CONNECTION_ERROR", message: error.localizedDescription, details: nil))
                        self.result = nil
                        self.isOpenPrintTagWriteMode = false
                        self.openPrintTagDataToWrite = nil
                        return
                    }
                    self.writeOpenPrintTag(iso15693Tag: iso15693Tag, data: dataToWrite, session: session)
                }
                return
            }

            // Si on est en mode OpenPrintTag ou Auto-Detect, lire le tag ISO 15693
            if self.isOpenPrintTagMode || self.isAutoDetectMode {
                session.connect(to: tag) { error in
                    if let error = error {
                        print("❌ Erreur connexion ISO 15693: \(error.localizedDescription)")
                        session.invalidate(errorMessage: "Erreur de connexion au tag")
                        self.result?(FlutterError(code: "CONNECTION_ERROR", message: error.localizedDescription, details: nil))
                        self.result = nil
                        self.isOpenPrintTagMode = false
                        return
                    }
                    self.readOpenPrintTag(iso15693Tag: iso15693Tag, session: session)
                }
                return
            }

            // Sinon, signaler un tag incompatible
            let tagInfo = "ISO 15693 (NFC-V) - ID: \(iso15693Tag.identifier.map { String(format: "%02x", $0) }.joined(separator: ":"))"
            session.invalidate(errorMessage: "Tag ISO 15693 détecté (non compatible)")
            self.result?(FlutterError(
                code: "INCOMPATIBLE_TAG",
                message: "Tag NFC détecté mais de type ISO 15693 (NFC-V). Ce type est utilisé par Prusa (OpenPrintTag) et n'est pas encore supporté dans ce mode. Sélectionnez le mode Prusa.",
                details: buildSessionDiagnostics(tagType: tagInfo)
            ))
            self.result = nil
            self.isBambuLabMode = false
            self.isOpenPrintTagMode = false
            self.isAutoDetectMode = false
            self.pagesToWrite = nil
            self.bambuBlocksToWrite = nil
            return
        }

        // Connecter au tag
        session.connect(to: tag) { error in
            if let error = error {
                print("❌ Erreur connexion: \(error.localizedDescription)")
                session.invalidate(errorMessage: "Erreur de connexion au tag")
                self.result?(FlutterError(code: "CONNECTION_ERROR", message: error.localizedDescription, details: nil))
                return
            }

            print("✅ Tag connecté")

            // Vérifier que c'est un tag MiFare
            guard case let .miFare(mifareTag) = tag else {
                // Tag détecté mais pas MiFare (pourrait être ISO 7816, FeliCa, etc.)
                var tagTypeDesc = "inconnu"
                switch tag {
                case .iso7816:
                    tagTypeDesc = "ISO 7816 (carte à puce)"
                case .feliCa:
                    tagTypeDesc = "FeliCa (Sony)"
                default:
                    tagTypeDesc = "non identifié"
                }
                print("⚠️ Tag détecté mais type non supporté: \(tagTypeDesc)")
                session.invalidate(errorMessage: "Tag de type \(tagTypeDesc) non compatible")
                self.result?(FlutterError(
                    code: "INCOMPATIBLE_TAG",
                    message: "Tag NFC détecté mais de type \(tagTypeDesc). L'app supporte les tags MiFare (Anycubic, Bambu Lab, Creality).",
                    details: self.buildSessionDiagnostics(tagType: tagTypeDesc)
                ))
                self.result = nil
                self.isBambuLabMode = false
                self.isAutoDetectMode = false
                return
            }

            // Lire ou écrire selon le mode
            if let pages = self.pagesToWrite {
                self.writePages(mifareTag: mifareTag, pages: pages, session: session)
            } else if let bambuBlocks = self.bambuBlocksToWrite {
                self.writeBambuLabClone(mifareTag: mifareTag, blocks: bambuBlocks, session: session)
            } else if self.isBambuLabMode || self.isAutoDetectMode {
                // Auto-détection du type de tag basée sur la famille MiFare
                // MiFare Ultralight (Anycubic/NTAG) vs MiFare Classic (Bambu Lab)
                let tagFamily = mifareTag.mifareFamily
                print("🔍 Famille MiFare détectée: \(tagFamily.rawValue)")

                switch tagFamily {
                case .ultralight:
                    // C'est un tag Anycubic/NTAG, lire en mode Ultralight et retourner avec flag
                    print("📖 Tag Ultralight détecté, lecture en mode Anycubic")
                    self.readAllPagesWithTagType(mifareTag: mifareTag, session: session, tagType: "ultralight")
                case .plus, .desfire:
                    // MiFare Classic/Plus détecté - Crypto1 non supporté par CoreNFC
                    print("⚠️ Tag MiFare Classic/Plus détecté - non supporté sur iOS")
                    session.invalidate(errorMessage: "MiFare Classic non supporté sur iOS")
                    self.result?(FlutterError(
                        code: "PLATFORM_NOT_SUPPORTED",
                        message: "Tag MiFare Classic détecté (Bambu Lab / Creality). Apple CoreNFC ne supporte pas le protocole Crypto1 requis. Utilisez un appareil Android.",
                        details: self.buildSessionDiagnostics(tagType: "mifare_classic")
                    ))
                    self.result = nil
                    self.isBambuLabMode = false
                    self.isAutoDetectMode = false
                default:
                    // Un tag .unknown est TRÈS souvent un NTAG Anycubic/Elegoo/TigerTag
                    // que CoreNFC n'a pas su classer .ultralight (fréquent sur iPhone
                    // récents / iOS 26). On tente donc TOUJOURS une lecture Ultralight
                    // — comme le mode manuel qui, lui, fonctionne. Si le tag est un vrai
                    // MiFare Classic (Bambu/Creality), la lecture de pages échouera et
                    // remontera une erreur générique côté Dart. Ne PAS rejeter d'emblée :
                    // c'était la cause du "MiFare inconnu" en auto-detect alors que le
                    // même tag se lisait en mode Anycubic.
                    print("🔎 Type MiFare inconnu (\(tagFamily.rawValue)), tentative de lecture Ultralight (NTAG probable)")
                    self.readAllPagesWithTagType(mifareTag: mifareTag, session: session, tagType: "ultralight")
                }
            } else {
                self.readAllPages(mifareTag: mifareTag, session: session)
            }
        }
    }

    // MARK: - OpenPrintTag ISO 15693 Writing

    private func writeOpenPrintTag(iso15693Tag: NFCISO15693Tag, data: [UInt8], session: NFCTagReaderSession) {
        print("✍️ Écriture OpenPrintTag ISO 15693: \(data.count) bytes")

        // ISO 15693 blocks are 4 bytes each
        let blockSize = 4
        let totalBlocks = (data.count + blockSize - 1) / blockSize

        // Pad data to fill the last block
        var paddedData = data
        while paddedData.count % blockSize != 0 {
            paddedData.append(0x00)
        }

        writeISO15693BlocksSequentially(
            iso15693Tag: iso15693Tag,
            data: paddedData,
            blockSize: blockSize,
            totalBlocks: totalBlocks,
            currentBlock: 0,
            session: session
        )
    }

    private func writeISO15693BlocksSequentially(
        iso15693Tag: NFCISO15693Tag,
        data: [UInt8],
        blockSize: Int,
        totalBlocks: Int,
        currentBlock: Int,
        session: NFCTagReaderSession
    ) {
        if currentBlock >= totalBlocks {
            print("✅ Écriture OpenPrintTag terminée: \(totalBlocks) blocs écrits")
            session.alertMessage = "Écriture OpenPrintTag réussie ✓"
            session.invalidate()
            self.result?(true)
            self.result = nil
            self.isOpenPrintTagWriteMode = false
            self.openPrintTagDataToWrite = nil
            return
        }

        let startIdx = currentBlock * blockSize
        let blockData = Data(data[startIdx..<(startIdx + blockSize)])

        iso15693Tag.writeSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: UInt8(currentBlock), dataBlock: blockData) { error in
            if let error = error {
                print("❌ Erreur écriture bloc \(currentBlock): \(error.localizedDescription)")
                session.invalidate(errorMessage: "Erreur écriture bloc \(currentBlock)")
                self.result?(FlutterError(code: "WRITE_ERROR", message: "Erreur écriture bloc \(currentBlock): \(error.localizedDescription)", details: nil))
                self.result = nil
                self.isOpenPrintTagWriteMode = false
                self.openPrintTagDataToWrite = nil
                return
            }

            print("📤 Bloc \(currentBlock)/\(totalBlocks-1) écrit: \(blockData.map { String(format: "%02x", $0) }.joined(separator: " "))")

            self.writeISO15693BlocksSequentially(
                iso15693Tag: iso15693Tag,
                data: data,
                blockSize: blockSize,
                totalBlocks: totalBlocks,
                currentBlock: currentBlock + 1,
                session: session
            )
        }
    }

    // MARK: - OpenPrintTag ISO 15693 Reading

    private func readOpenPrintTag(iso15693Tag: NFCISO15693Tag, session: NFCTagReaderSession) {
        print("📖 Lecture OpenPrintTag ISO 15693...")

        // Read blocks sequentially (4 bytes per block for ISO 15693)
        // Read up to 64 blocks (256 bytes) to cover NDEF + OpenPrintTag data
        readISO15693BlocksSequentially(
            iso15693Tag: iso15693Tag,
            currentBlock: 0,
            maxBlocks: 64,
            allData: Data(),
            session: session
        )
    }

    private func readISO15693BlocksSequentially(
        iso15693Tag: NFCISO15693Tag,
        currentBlock: Int,
        maxBlocks: Int,
        allData: Data,
        session: NFCTagReaderSession
    ) {
        if currentBlock >= maxBlocks {
            // Done reading, return raw bytes
            print("📄 OpenPrintTag: \(allData.count) bytes lus")
            print("🔍 Hex: \(allData.map { String(format: "%02x", $0) }.joined(separator: " "))")

            var resultData: [String: Any] = [
                "rawBytes": [UInt8](allData)
            ]
            if self.isAutoDetectMode {
                resultData["tagType"] = "prusa"
            }

            session.alertMessage = "Lecture Prusa réussie ✓"
            session.invalidate()
            self.result?(resultData)
            self.result = nil
            self.isOpenPrintTagMode = false
            self.isAutoDetectMode = false
            return
        }

        iso15693Tag.readSingleBlock(requestFlags: [.highDataRate, .address], blockNumber: UInt8(currentBlock)) { data, error in
            if let error = error {
                // If we get an error on a block, we've reached the end of readable memory
                if currentBlock > 0 {
                    print("📄 OpenPrintTag: fin de lecture au bloc \(currentBlock), \(allData.count) bytes lus")
                    print("🔍 Hex: \(allData.map { String(format: "%02x", $0) }.joined(separator: " "))")

                    let resultData: [String: Any] = [
                        "rawBytes": [UInt8](allData)
                    ]

                    session.alertMessage = "Lecture Prusa réussie ✓"
                    session.invalidate()
                    self.result?(resultData)
                    self.result = nil
                    self.isOpenPrintTagMode = false
                    return
                }

                // Error on first block
                print("❌ Erreur lecture ISO 15693 bloc \(currentBlock): \(error.localizedDescription)")
                session.invalidate(errorMessage: "Erreur de lecture ISO 15693")
                self.result?(FlutterError(code: "READ_ERROR", message: error.localizedDescription, details: nil))
                self.result = nil
                self.isOpenPrintTagMode = false
                self.isAutoDetectMode = false
                return
            }

            var newData = allData
            newData.append(data)

            // Check for NDEF terminator TLV (0xFE)
            if data.contains(0xFE) && currentBlock > 4 {
                print("📄 OpenPrintTag: terminateur NDEF trouvé au bloc \(currentBlock)")
                print("🔍 Hex: \(newData.map { String(format: "%02x", $0) }.joined(separator: " "))")

                var resultData: [String: Any] = [
                    "rawBytes": [UInt8](newData)
                ]
                if self.isAutoDetectMode {
                    resultData["tagType"] = "prusa"
                }

                session.alertMessage = "Lecture Prusa réussie ✓"
                session.invalidate()
                self.result?(resultData)
                self.result = nil
                self.isOpenPrintTagMode = false
                self.isAutoDetectMode = false
                return
            }

            // Read next block
            self.readISO15693BlocksSequentially(
                iso15693Tag: iso15693Tag,
                currentBlock: currentBlock + 1,
                maxBlocks: maxBlocks,
                allData: newData,
                session: session
            )
        }
    }

    private func readAllPages(mifareTag: NFCMiFareTag, session: NFCTagReaderSession) {
        // Lire toutes les pages séquentiellement
        readPageSequentially(mifareTag: mifareTag, startPage: 0, allData: Data(), session: session)
    }

    /// Lire toutes les pages avec indication du type de tag détecté
    private func readAllPagesWithTagType(mifareTag: NFCMiFareTag, session: NFCTagReaderSession, tagType: String) {
        readPageSequentiallyWithTagType(mifareTag: mifareTag, startPage: 0, allData: Data(), session: session, tagType: tagType)
    }

    private func readPageSequentiallyWithTagType(mifareTag: NFCMiFareTag, startPage: Int, allData: Data, session: NFCTagReaderSession, tagType: String) {
        // Si on a fini de lire toutes les pages
        if startPage >= 40 {
            let dataString = String(data: allData, encoding: .utf8) ?? ""
            print("📄 Données complètes: \(dataString)")

            let resultData: [String: Any] = [
                "data": dataString,
                "rawBytes": [UInt8](allData),
                "tagType": tagType  // Retourner le type de tag détecté
            ]

            session.alertMessage = "Lecture réussie ✓"
            session.invalidate()
            self.result?(resultData)
            self.result = nil
            self.isBambuLabMode = false
            self.isAutoDetectMode = false
            return
        }

        // Commande READ MiFare Ultralight: 0x30 + page number
        let command = Data([0x30, UInt8(startPage)])

        mifareTag.sendMiFareCommand(commandPacket: command) { data, error in
            if let error = error {
                print("⚠️ Erreur lecture page \(startPage): \(error.localizedDescription)")
                session.invalidate(errorMessage: "Erreur de lecture")
                self.result?(FlutterError(code: "READ_ERROR", message: error.localizedDescription, details: nil))
                self.result = nil
                self.isAutoDetectMode = false
                self.isBambuLabMode = false
                self.isAutoDetectMode = false
                return
            }

            print("📦 Pages \(startPage)-\(startPage+3): \(data.map { String(format: "%02x", $0) }.joined(separator: " "))")

            var newData = allData
            newData.append(data)

            // Lire les 4 pages suivantes
            self.readPageSequentiallyWithTagType(mifareTag: mifareTag, startPage: startPage + 4, allData: newData, session: session, tagType: tagType)
        }
    }

    private func readPageSequentially(mifareTag: NFCMiFareTag, startPage: Int, allData: Data, session: NFCTagReaderSession) {
        // Si on a fini de lire toutes les pages (lire jusqu'à page 40 pour capturer couleur/advanced settings)
        if startPage >= 40 {
            let dataString = String(data: allData, encoding: .utf8) ?? ""
            print("📄 Données complètes: \(dataString)")

            let resultData: [String: Any] = [
                "data": dataString,
                "rawBytes": [UInt8](allData)
            ]

            session.alertMessage = "Lecture réussie ✓"
            session.invalidate()
            self.result?(resultData)
            self.result = nil
            return
        }

        // Commande READ MiFare Ultralight: 0x30 + page number
        let command = Data([0x30, UInt8(startPage)])

        mifareTag.sendMiFareCommand(commandPacket: command) { data, error in
            if let error = error {
                print("⚠️ Erreur lecture page \(startPage): \(error.localizedDescription)")
                session.invalidate(errorMessage: "Erreur de lecture")
                self.result?(FlutterError(code: "READ_ERROR", message: error.localizedDescription, details: nil))
                self.result = nil
                return
            }

            print("📦 Pages \(startPage)-\(startPage+3): \(data.map { String(format: "%02x", $0) }.joined(separator: " "))")

            var newData = allData
            newData.append(data)

            // Lire les 4 pages suivantes
            self.readPageSequentially(mifareTag: mifareTag, startPage: startPage + 4, allData: newData, session: session)
        }
    }

    private func writePages(mifareTag: NFCMiFareTag, pages: [[String: Any]], session: NFCTagReaderSession) {
        // Écrire toutes les pages séquentiellement
        writePageSequentially(mifareTag: mifareTag, pages: pages, currentIndex: 0, session: session)
    }

    private func writePageSequentially(mifareTag: NFCMiFareTag, pages: [[String: Any]], currentIndex: Int, session: NFCTagReaderSession) {
        // Si on a fini d'écrire toutes les pages
        if currentIndex >= pages.count {
            session.alertMessage = "Écriture réussie ✓"
            session.invalidate()
            self.result?(true)
            self.result = nil
            self.pagesToWrite = nil  // Réinitialiser pour la prochaine session
            return
        }

        let pageInfo = pages[currentIndex]
        guard let pageNumber = pageInfo["page"] as? Int,
              let dataArray = pageInfo["data"] as? [UInt8],
              dataArray.count == 4 else {
            print("⚠️ Page invalide: \(pageInfo)")
            // Passer à la page suivante
            self.writePageSequentially(mifareTag: mifareTag, pages: pages, currentIndex: currentIndex + 1, session: session)
            return
        }

        // Commande WRITE MiFare Ultralight: 0xA2 + page number + 4 bytes
        var command = Data([0xA2, UInt8(pageNumber)])
        command.append(contentsOf: dataArray)

        print("📤 Écriture page \(pageNumber): \(dataArray.map { String(format: "%02x", $0) }.joined(separator: " "))")

        mifareTag.sendMiFareCommand(commandPacket: command) { data, error in
            if let error = error {
                print("❌ Erreur écriture page \(pageNumber): \(error.localizedDescription)")
                session.invalidate(errorMessage: "Erreur lors de l'écriture")
                self.result?(FlutterError(code: "WRITE_ERROR", message: "Échec de l'écriture", details: nil))
                self.result = nil
                self.pagesToWrite = nil  // Réinitialiser aussi en cas d'erreur
                return
            }

            print("✅ Page \(pageNumber) écrite")

            // Écrire la page suivante
            self.writePageSequentially(mifareTag: mifareTag, pages: pages, currentIndex: currentIndex + 1, session: session)
        }
    }

    // MARK: - Bambu Lab HKDF Key Derivation

    /// HKDF-Extract: PRK = HMAC-SHA256(salt, ikm)
    private func hkdfExtract(salt: Data, ikm: Data) -> Data {
        var hmac = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        salt.withUnsafeBytes { saltPtr in
            ikm.withUnsafeBytes { ikmPtr in
                CCHmac(
                    CCHmacAlgorithm(kCCHmacAlgSHA256),
                    saltPtr.baseAddress, salt.count,
                    ikmPtr.baseAddress, ikm.count,
                    &hmac
                )
            }
        }
        return Data(hmac)
    }

    /// HKDF-Expand: OKM = T(1) || T(2) || ... truncated to length
    private func hkdfExpand(prk: Data, info: Data, length: Int) -> Data {
        let hashLen = Int(CC_SHA256_DIGEST_LENGTH) // 32
        let n = (length + hashLen - 1) / hashLen
        var okm = Data()
        var t = Data() // T(0) is empty

        for i in 1...n {
            var input = Data()
            input.append(t)
            input.append(info)
            input.append(UInt8(i))

            var hmac = [UInt8](repeating: 0, count: hashLen)
            prk.withUnsafeBytes { prkPtr in
                input.withUnsafeBytes { inputPtr in
                    CCHmac(
                        CCHmacAlgorithm(kCCHmacAlgSHA256),
                        prkPtr.baseAddress, prk.count,
                        inputPtr.baseAddress, input.count,
                        &hmac
                    )
                }
            }
            t = Data(hmac)
            okm.append(t)
        }
        return okm.prefix(length)
    }

    /// Derive 16 MiFare Classic Key-A values (6 bytes each) from tag UID
    private func deriveBambuKeys(uid: Data) -> [Data] {
        let salt = Data([0x9a, 0x75, 0x9c, 0xf2, 0xc4, 0xf7, 0xca, 0xff,
                         0x22, 0x2c, 0xb9, 0x76, 0x9b, 0x41, 0xbc, 0x96])
        let info = Data([0x52, 0x46, 0x49, 0x44, 0x2d, 0x41, 0x00]) // "RFID-A\0"

        let prk = hkdfExtract(salt: salt, ikm: uid)
        let okm = hkdfExpand(prk: prk, info: info, length: 6 * 16) // 96 bytes

        var keys: [Data] = []
        for i in 0..<16 {
            let start = i * 6
            keys.append(okm.subdata(in: start..<(start + 6)))
        }
        return keys
    }

    // MARK: - Bambu Lab MiFare Classic Reading

    private func readBambuLabTag(mifareTag: NFCMiFareTag, session: NFCTagReaderSession) {
        // MiFare Classic authentication (Crypto1) n'est pas supporté par Apple CoreNFC.
        // Le hardware iPhone détecte les tags MiFare Classic (UID lisible) mais
        // ne peut pas effectuer l'authentification sectorielle requise.
        print("⚠️ Tentative de lecture Bambu Lab (MiFare Classic) sur iOS - non supporté")
        session.invalidate(errorMessage: "MiFare Classic non supporté sur iOS")
        self.result?(FlutterError(
            code: "PLATFORM_NOT_SUPPORTED",
            message: "Les tags Bambu Lab utilisent MiFare Classic qui n'est pas supporté par Apple CoreNFC. Cette fonctionnalité est disponible sur Android uniquement.",
            details: nil
        ))
        self.result = nil
        self.isBambuLabMode = false
        self.isAutoDetectMode = false
        return

        // --- Code original conservé pour référence (ne s'exécute jamais) ---
        // Derive HKDF keys from tag UID for genuine Bambu Lab tags
        let uid = mifareTag.identifier
        let derivedKeys = deriveBambuKeys(uid: uid)
        let defaultKey = Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])

        print("🔑 Bambu Lab: UID = \(uid.map { String(format: "%02x", $0) }.joined(separator: " "))")

        // Build list of blocks to read (skip sector trailers)
        var blocksToRead: [Int] = []
        for sector in 0..<16 {
            for blockInSector in 0..<4 {
                if blockInSector == 3 { continue }
                blocksToRead.append(sector * 4 + blockInSector)
            }
        }

        readBambuBlocks(
            mifareTag: mifareTag,
            blocks: blocksToRead,
            derivedKeys: derivedKeys,
            defaultKey: defaultKey,
            blockData: [:],
            currentIndex: 0,
            session: session
        )
    }

    private func readBambuBlocks(
        mifareTag: NFCMiFareTag,
        blocks: [Int],
        derivedKeys: [Data],
        defaultKey: Data,
        blockData: [Int: Data],
        currentIndex: Int,
        session: NFCTagReaderSession
    ) {
        // If we've read all blocks, parse and return data
        if currentIndex >= blocks.count {
            var parsedData = parseBambuLabData(blockData: blockData)
            if self.isAutoDetectMode {
                parsedData["tagType"] = "bambu"
            }
            session.alertMessage = "Lecture Bambu Lab réussie ✓"
            session.invalidate()
            self.result?(parsedData)
            self.result = nil
            self.isBambuLabMode = false
            self.isAutoDetectMode = false
            return
        }

        let blockNumber = blocks[currentIndex]
        let sector = blockNumber / 4

        // Authenticate with HKDF-derived key first, fallback to default
        authenticateSectorWithFallback(
            mifareTag: mifareTag,
            sector: UInt8(sector),
            derivedKey: derivedKeys[sector],
            defaultKey: defaultKey
        ) { success, error in
            if !success {
                print("❌ Échec authentification secteur \(sector) (les deux clés)")
                session.invalidate(errorMessage: "Échec d'authentification")
                self.result?(FlutterError(
                    code: "AUTH_ERROR",
                    message: "Impossible d'authentifier le secteur \(sector)",
                    details: nil
                ))
                self.result = nil
                self.isBambuLabMode = false
                self.isAutoDetectMode = false
                return
            }

            // Read block
            self.readMifareClassicBlock(
                mifareTag: mifareTag,
                blockNumber: UInt8(blockNumber)
            ) { data, error in
                if let error = error {
                    print("❌ Erreur lecture bloc \(blockNumber): \(error)")
                    session.invalidate(errorMessage: "Erreur de lecture")
                    self.result?(FlutterError(
                        code: "READ_ERROR",
                        message: "Échec lecture bloc \(blockNumber)",
                        details: nil
                    ))
                    self.result = nil
                    self.isBambuLabMode = false
                    return
                }

                if let data = data {
                    print("✅ Bloc \(blockNumber): \(data.map { String(format: "%02x", $0) }.joined(separator: " "))")
                    var updatedBlockData = blockData
                    updatedBlockData[blockNumber] = data

                    // Read next block
                    self.readBambuBlocks(
                        mifareTag: mifareTag,
                        blocks: blocks,
                        derivedKeys: derivedKeys,
                        defaultKey: defaultKey,
                        blockData: updatedBlockData,
                        currentIndex: currentIndex + 1,
                        session: session
                    )
                }
            }
        }
    }

    /// Try HKDF-derived key first, then fallback to default FF key
    private func authenticateSectorWithFallback(
        mifareTag: NFCMiFareTag,
        sector: UInt8,
        derivedKey: Data,
        defaultKey: Data,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        authenticateSector(mifareTag: mifareTag, sector: sector, key: derivedKey) { success, _ in
            if success {
                completion(true, nil)
            } else {
                // Fallback to default key (CUID cards / blank tags)
                print("🔄 Secteur \(sector): clé HKDF échouée, essai clé par défaut")
                self.authenticateSector(mifareTag: mifareTag, sector: sector, key: defaultKey) { success2, error2 in
                    completion(success2, error2)
                }
            }
        }
    }

    private func authenticateSector(
        mifareTag: NFCMiFareTag,
        sector: UInt8,
        key: Data,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        // MiFare Classic authentication command
        // 0x60 = Auth with Key A
        // sector = sector number
        // key = 6 bytes authentication key

        var command = Data([0x60, sector])
        command.append(key)

        mifareTag.sendMiFareCommand(commandPacket: command) { data, error in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }

    private func readMifareClassicBlock(
        mifareTag: NFCMiFareTag,
        blockNumber: UInt8,
        completion: @escaping (Data?, Error?) -> Void
    ) {
        // MiFare Classic read command
        // 0x30 = READ
        // blockNumber = block to read

        let command = Data([0x30, blockNumber])

        mifareTag.sendMiFareCommand(commandPacket: command) { data, error in
            if let error = error {
                completion(nil, error)
                return
            }
            completion(data, nil)
        }
    }

    private func parseBambuLabData(blockData: [Int: Data]) -> [String: Any] {
        // Parse according to Bambu Lab RFID specification
        // Block 2: Tag UID & Basic Info
        // Block 5: Filament type & temperatures
        // Block 6: Color & additional settings
        // Block 12: Production date & batch
        // Block 14: Detailed material properties

        var result: [String: Any] = [:]

        // Extract raw bytes for each block
        var rawBlocks: [String: [UInt8]] = [:]
        for (blockNum, data) in blockData {
            rawBlocks["block_\(blockNum)"] = [UInt8](data)
        }
        result["rawBlocks"] = rawBlocks

        // Parse block 5: Filament type and temperatures
        if let block5 = blockData[5], block5.count >= 16 {
            // Bytes 0-1: Material type index
            let materialIndex = Int(block5[0])
            result["materialIndex"] = materialIndex

            // Bytes 4-5: Nozzle temp min (little endian)
            let nozzleTempMin = Int(block5[4]) | (Int(block5[5]) << 8)
            result["extruderTempMin"] = nozzleTempMin

            // Bytes 6-7: Nozzle temp max (little endian)
            let nozzleTempMax = Int(block5[6]) | (Int(block5[7]) << 8)
            result["extruderTempMax"] = nozzleTempMax

            // Bytes 8-9: Bed temp min (little endian)
            let bedTempMin = Int(block5[8]) | (Int(block5[9]) << 8)
            result["bedTempMin"] = bedTempMin

            // Bytes 10-11: Bed temp max (little endian)
            let bedTempMax = Int(block5[10]) | (Int(block5[11]) << 8)
            result["bedTempMax"] = bedTempMax
        }

        // Parse block 6: Color
        if let block6 = blockData[6], block6.count >= 16 {
            // Bytes 0-3: Color RGBA (but stored as ARGB in some implementations)
            let r = Int(block6[0])
            let g = Int(block6[1])
            let b = Int(block6[2])
            let a = Int(block6[3])

            // Store as 0xAARRGGBB integer
            let colorRgb = (a << 24) | (r << 16) | (g << 8) | b
            result["colorRgb"] = colorRgb
        }

        // Parse block 12: Production date
        if let block12 = blockData[12], block12.count >= 16 {
            // Bytes 0-3: Production date (Unix timestamp or custom format)
            // This varies by implementation - extracting raw value
            let timestamp = Int(block12[0]) | (Int(block12[1]) << 8) | (Int(block12[2]) << 16) | (Int(block12[3]) << 24)
            result["productionTimestamp"] = timestamp
        }

        // Parse block 14: Detailed properties
        if let block14 = blockData[14], block14.count >= 16 {
            // Bytes 0-1: Spool weight (grams, little endian)
            let weight = Int(block14[0]) | (Int(block14[1]) << 8)
            result["weightGrams"] = weight

            // Bytes 2-3: Spool length (meters, little endian)
            let length = Int(block14[2]) | (Int(block14[3]) << 8)
            result["spoolLength"] = length

            // Bytes 4-5: Diameter (0.01mm units, little endian)
            let diameterRaw = Int(block14[4]) | (Int(block14[5]) << 8)
            let diameter = Double(diameterRaw) / 100.0
            result["diameter"] = diameter
        }

        return result
    }

    // MARK: - Bambu Lab Clone Writing (CUID Cards)

    private func writeBambuLabClone(mifareTag: NFCMiFareTag, blocks: [String: [UInt8]], session: NFCTagReaderSession) {
        print("🖊️ Début écriture clone Bambu Lab sur carte CUID")

        // Convertir les clés String en Int et trier
        var blockNumbers: [Int] = []
        var blockDataMap: [Int: Data] = [:]

        for (key, value) in blocks {
            if let blockNum = Int(key) {
                blockNumbers.append(blockNum)
                blockDataMap[blockNum] = Data(value)
            }
        }

        blockNumbers.sort()

        let defaultKey = Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])

        // Écrire tous les blocs séquentiellement
        writeBambuBlocksSequentially(
            mifareTag: mifareTag,
            blockNumbers: blockNumbers,
            blockDataMap: blockDataMap,
            key: defaultKey,
            currentIndex: 0,
            session: session
        )
    }

    private func writeBambuBlocksSequentially(
        mifareTag: NFCMiFareTag,
        blockNumbers: [Int],
        blockDataMap: [Int: Data],
        key: Data,
        currentIndex: Int,
        session: NFCTagReaderSession
    ) {
        // Si tous les blocs sont écrits
        if currentIndex >= blockNumbers.count {
            session.alertMessage = "Clone Bambu Lab écrit avec succès ✓"
            session.invalidate()
            self.result?(true)
            self.result = nil
            self.bambuBlocksToWrite = nil
            return
        }

        let blockNumber = blockNumbers[currentIndex]

        // IMPORTANT: Ne jamais écrire les sector trailers (blocs 3, 7, 11, 15...)
        // Ils contiennent les clés d'authentification et sont protégés
        let blockInSector = blockNumber % 4
        if blockInSector == 3 {
            print("⏭️ Skip sector trailer bloc \(blockNumber)")
            // Passer au bloc suivant
            writeBambuBlocksSequentially(
                mifareTag: mifareTag,
                blockNumbers: blockNumbers,
                blockDataMap: blockDataMap,
                key: key,
                currentIndex: currentIndex + 1,
                session: session
            )
            return
        }

        guard let blockData = blockDataMap[blockNumber] else {
            // Passer au bloc suivant
            writeBambuBlocksSequentially(
                mifareTag: mifareTag,
                blockNumbers: blockNumbers,
                blockDataMap: blockDataMap,
                key: key,
                currentIndex: currentIndex + 1,
                session: session
            )
            return
        }

        let sector = blockNumber / 4

        // Authentifier le secteur
        authenticateSector(mifareTag: mifareTag, sector: UInt8(sector), key: key) { success, error in
            if !success {
                print("❌ Échec authentification secteur \(sector)")
                session.invalidate(errorMessage: "Erreur d'authentification")
                self.result?(FlutterError(
                    code: "AUTH_ERROR",
                    message: "Impossible d'authentifier le secteur \(sector)",
                    details: nil
                ))
                self.result = nil
                self.bambuBlocksToWrite = nil
                return
            }

            // Écrire le bloc
            self.writeMifareClassicBlock(
                mifareTag: mifareTag,
                blockNumber: UInt8(blockNumber),
                data: blockData
            ) { success, error in
                if !success {
                    print("❌ Erreur écriture bloc \(blockNumber)")
                    session.invalidate(errorMessage: "Erreur d'écriture")
                    self.result?(FlutterError(
                        code: "WRITE_ERROR",
                        message: "Échec écriture bloc \(blockNumber)",
                        details: nil
                    ))
                    self.result = nil
                    self.bambuBlocksToWrite = nil
                    return
                }

                print("✅ Bloc \(blockNumber) écrit: \(blockData.map { String(format: "%02x", $0) }.joined(separator: " "))")

                // Écrire le bloc suivant
                self.writeBambuBlocksSequentially(
                    mifareTag: mifareTag,
                    blockNumbers: blockNumbers,
                    blockDataMap: blockDataMap,
                    key: key,
                    currentIndex: currentIndex + 1,
                    session: session
                )
            }
        }
    }

    private func writeMifareClassicBlock(
        mifareTag: NFCMiFareTag,
        blockNumber: UInt8,
        data: Data,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        // MiFare Classic write command
        // 0xA0 = WRITE (for CUID cards)
        // blockNumber = block to write
        // data = 16 bytes to write
        //
        // NOTE: Block 0 (UID) peut nécessiter une commande spéciale sur certaines cartes CUID
        // La commande 0xA0 standard fonctionne sur la plupart des cartes CUID modernes
        // Si l'écriture du Block 0 échoue, essayer avec une carte CUID Gen2 ou Magic Gen4

        var command = Data([0xA0, blockNumber])

        // S'assurer que les données font exactement 16 bytes
        var dataToWrite = data
        if dataToWrite.count < 16 {
            dataToWrite.append(Data(repeating: 0x00, count: 16 - dataToWrite.count))
        } else if dataToWrite.count > 16 {
            dataToWrite = dataToWrite.prefix(16)
        }

        command.append(dataToWrite)

        mifareTag.sendMiFareCommand(commandPacket: command) { responseData, error in
            if let error = error {
                completion(false, error)
                return
            }
            completion(true, nil)
        }
    }
}
