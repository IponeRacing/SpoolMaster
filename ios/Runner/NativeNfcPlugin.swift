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
    private var bambuBlocksToWrite: [String: [UInt8]]?

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startReadSession":
            startReadSession(result: result)
        case "startWriteSession":
            guard let args = call.arguments as? [String: Any],
                  let pages = args["pages"] as? [[String: Any]] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing pages argument", details: nil))
                return
            }
            startWriteSession(pages: pages, result: result)
        case "readBambuLabTag":
            startBambuLabReadSession(result: result)
        case "writeBambuLabClone":
            guard let args = call.arguments as? [String: Any],
                  let blocks = args["blocks"] as? [String: [UInt8]] else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing blocks argument", details: nil))
                return
            }
            startBambuLabWriteSession(blocks: blocks, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func startReadSession(result: @escaping FlutterResult) {
        self.result = result

        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "Maintenez votre téléphone près du tag NFC"
        session?.begin()
    }

    private func startWriteSession(pages: [[String: Any]], result: @escaping FlutterResult) {
        self.result = result
        self.pagesToWrite = pages
        self.isBambuLabMode = false

        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "Maintenez votre téléphone près du tag NFC pour écriture"
        session?.begin()
    }

    private func startBambuLabReadSession(result: @escaping FlutterResult) {
        self.result = result
        self.isBambuLabMode = true

        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "Maintenez votre téléphone près du tag Bambu Lab"
        session?.begin()
    }

    private func startBambuLabWriteSession(blocks: [String: [UInt8]], result: @escaping FlutterResult) {
        self.result = result
        self.bambuBlocksToWrite = blocks

        session = NFCTagReaderSession(pollingOption: .iso14443, delegate: self)
        session?.alertMessage = "Maintenez votre téléphone près de la carte CUID vierge"
        session?.begin()
    }
}

extension NativeNfcPlugin: NFCTagReaderSessionDelegate {
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        print("📱 Session NFC active")
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("❌ Session invalidée: \(error.localizedDescription)")
        result?(FlutterError(code: "SESSION_ERROR", message: error.localizedDescription, details: nil))
        self.result = nil
    }

    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        guard let tag = tags.first else {
            result?(FlutterError(code: "NO_TAG", message: "Aucun tag détecté", details: nil))
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
                session.invalidate(errorMessage: "Tag non compatible")
                self.result?(FlutterError(code: "INVALID_TAG", message: "Tag non MiFare", details: nil))
                return
            }

            // Lire ou écrire selon le mode
            if let pages = self.pagesToWrite {
                self.writePages(mifareTag: mifareTag, pages: pages, session: session)
            } else if let bambuBlocks = self.bambuBlocksToWrite {
                self.writeBambuLabClone(mifareTag: mifareTag, blocks: bambuBlocks, session: session)
            } else if self.isBambuLabMode {
                self.readBambuLabTag(mifareTag: mifareTag, session: session)
            } else {
                self.readAllPages(mifareTag: mifareTag, session: session)
            }
        }
    }

    private func readAllPages(mifareTag: NFCMiFareTag, session: NFCTagReaderSession) {
        // Lire toutes les pages séquentiellement
        readPageSequentially(mifareTag: mifareTag, startPage: 0, allData: Data(), session: session)
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

    // MARK: - Bambu Lab MiFare Classic Reading

    private func readBambuLabTag(mifareTag: NFCMiFareTag, session: NFCTagReaderSession) {
        // Bambu Lab uses MiFare Classic 1K with specific block structure
        // Read ALL blocks to enable cloning (including signature)
        // Default key: FF FF FF FF FF FF

        let defaultKey = Data([0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
        var blockData: [Int: Data] = [:]

        // Read ALL blocks from MiFare Classic 1K (64 blocks total, 16 sectors)
        // We need ALL data blocks including Block 0 (UID) for successful cloning
        // Skip ONLY sector trailers (blocks 3, 7, 11, 15, 19, 23, 27, 31, 35, 39, 43, 47, 51, 55, 59, 63)
        var blocksToRead: [Int] = []
        for sector in 0..<16 {
            for blockInSector in 0..<4 {
                let blockNum = sector * 4 + blockInSector
                // Skip sector trailer (every 4th block: 3, 7, 11, 15...)
                if blockInSector == 3 {
                    continue
                }
                blocksToRead.append(blockNum)
            }
        }
        // Result: blocks 0,1,2, 4,5,6, 8,9,10, 12,13,14, etc. (48 total blocks)

        readBambuBlocks(
            mifareTag: mifareTag,
            blocks: blocksToRead,
            key: defaultKey,
            blockData: blockData,
            currentIndex: 0,
            session: session
        )
    }

    private func readBambuBlocks(
        mifareTag: NFCMiFareTag,
        blocks: [Int],
        key: Data,
        blockData: [Int: Data],
        currentIndex: Int,
        session: NFCTagReaderSession
    ) {
        // If we've read all blocks, parse and return data
        if currentIndex >= blocks.count {
            let parsedData = parseBambuLabData(blockData: blockData)
            session.alertMessage = "Lecture Bambu Lab réussie ✓"
            session.invalidate()
            self.result?(parsedData)
            self.result = nil
            self.isBambuLabMode = false
            return
        }

        let blockNumber = blocks[currentIndex]
        let sector = blockNumber / 4

        // Authenticate to sector
        authenticateSector(
            mifareTag: mifareTag,
            sector: UInt8(sector),
            key: key
        ) { success, error in
            if !success {
                print("❌ Échec authentification secteur \(sector)")
                session.invalidate(errorMessage: "Échec d'authentification")
                self.result?(FlutterError(
                    code: "AUTH_ERROR",
                    message: "Impossible d'authentifier le secteur \(sector)",
                    details: nil
                ))
                self.result = nil
                self.isBambuLabMode = false
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
                        key: key,
                        blockData: updatedBlockData,
                        currentIndex: currentIndex + 1,
                        session: session
                    )
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
