package com.engagengine.nfc_anycubic

import android.app.Activity
import android.app.PendingIntent
import android.content.Intent
import android.content.IntentFilter
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.TagLostException
import android.nfc.tech.IsoDep
import android.nfc.tech.MifareClassic
import android.nfc.tech.MifareUltralight
import android.nfc.tech.NfcA
import android.nfc.tech.NfcV
import android.nfc.tech.TagTechnology
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.IOException
import javax.crypto.Cipher
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

/**
 * Native NFC Plugin for Android
 * Implements Method Channel: com.anycubic.nfc/native
 *
 * Supports:
 * - MiFare Ultralight (Anycubic/NTAG tags)
 * - MiFare Classic 1K (Bambu Lab tags)
 * - MiFare Classic 1K (Creality CFS tags)
 * - CUID card cloning
 */
class NativeNfcPlugin private constructor(
    private val activity: Activity
) : MethodChannel.MethodCallHandler, NfcAdapter.ReaderCallback {

    companion object {
        private const val TAG = "NativeNfcPlugin"
        private const val CHANNEL_NAME = "com.anycubic.nfc/native"

        // MiFare commands
        private const val CMD_READ: Byte = 0x30
        private const val CMD_WRITE_ULTRALIGHT: Byte = 0xA2.toByte()

        // Nombre de passes de lecture avant d'abandonner. Chaque passe reprend à
        // la page en échec, avec le tag le plus récent fourni par Android.
        // Récupère les décrochages transitoires quand le tag bouge un peu.
        private const val READ_ATTEMPTS: Int = 3

        // Lecture Anycubic : pages 0-39 = 160 octets. Une lecture plus courte
        // est un échec (PARTIAL_READ), jamais un succès.
        private const val ANYCUBIC_PAGES: Int = 40
        private const val ANYCUBIC_READ_BYTES: Int = ANYCUBIC_PAGES * 4

        // Tag NDEF (OpenSpool, OpenTag3D…) dont le message dépasse la page 39 :
        // lecture prolongée jusqu'à la fin du message, au plus NTAG216 (231 pages).
        private const val TYPE2_MAX_PAGES: Int = 231

        // Connexion : 3 tentatives espacées de 100 ms. connect() peut lever une
        // IOException sans message juste après la détection (d'où « Read failed »).
        private const val CONNECT_ATTEMPTS: Int = 3
        private const val CONNECT_RETRY_DELAY_MS: Long = 100L

        // ISO 15693 : plafond de lecture (adresse de bloc sur 1 octet). Un SLIX2
        // compte 80 blocs ; la longueur réelle vient de l'en-tête TLV NDEF.
        private const val NFCV_MAX_BLOCKS: Int = 256

        // Le Dart (NfcReaderBloc._isTagMovedFailure) reconnaît « tag was lost »
        // dans le message pour afficher « reposez le tag sans bouger ».
        private const val TAG_LOST_HINT = "Tag was lost"

        // Vendor Creality CFS attendu après déchiffrement (octets 8-11).
        private const val CREALITY_VENDOR = "0276"

        // Default MiFare Classic key
        private val DEFAULT_KEY = byteArrayOf(
            0xFF.toByte(), 0xFF.toByte(), 0xFF.toByte(),
            0xFF.toByte(), 0xFF.toByte(), 0xFF.toByte()
        )

        // Bambu Lab HKDF parameters
        private val BAMBU_HKDF_SALT = byteArrayOf(
            0x9a.toByte(), 0x75, 0x9c.toByte(), 0xf2.toByte(),
            0xc4.toByte(), 0xf7.toByte(), 0xca.toByte(), 0xff.toByte(),
            0x22, 0x2c, 0xb9.toByte(), 0x76, 0x9b.toByte(), 0x41, 0xbc.toByte(), 0x96.toByte()
        )
        // "RFID-A\0" (7 bytes including null terminator)
        private val BAMBU_HKDF_INFO = byteArrayOf(0x52, 0x46, 0x49, 0x44, 0x2d, 0x41, 0x00)

        // Creality CFS parameters
        // AES key for sector key derivation from UID: "q3bu^t1nqfZ(pf$1"
        private val CREALITY_UID_KEY = byteArrayOf(
            0x71, 0x33, 0x62, 0x75, 0x5e, 0x74, 0x31, 0x6e,
            0x71, 0x66, 0x5a, 0x28, 0x70, 0x66, 0x24, 0x31
        )
        // AES-128-ECB key for data encryption: "H@CFkRnz@KAtBJp2"
        private val CREALITY_AES_KEY = byteArrayOf(
            0x48, 0x40, 0x43, 0x46, 0x6b, 0x52, 0x6e, 0x7a,
            0x40, 0x4b, 0x41, 0x74, 0x42, 0x4a, 0x70, 0x32
        )

        private var instance: NativeNfcPlugin? = null

        fun getInstance(): NativeNfcPlugin? = instance

        fun registerWith(flutterEngine: FlutterEngine, activity: Activity) {
            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
            instance = NativeNfcPlugin(activity)
            channel.setMethodCallHandler(instance)
            Log.d(TAG, "NativeNfcPlugin registered")
        }
    }

    private var nfcAdapter: NfcAdapter? = null
    private var pendingResult: MethodChannel.Result? = null
    @Volatile private var currentMode: NfcMode = NfcMode.IDLE

    // Session : chaque start*Session (et stopSession / timeout) incrémente l'id.
    // Un traitement lancé pour une session terminée ne doit plus répondre ni
    // toucher au reader mode (sinon il tue ou répond à la session suivante).
    @Volatile private var sessionId: Int = 0
    // Traitement du tag en cours (annulé par stopSession et par une nouvelle session).
    @Volatile private var currentJob: Job? = null
    // Id de session du traitement exécuté sur ce thread, propagé dans la
    // coroutine via asContextElement (lu par sendSuccess / sendError).
    private val handlerSessionId = ThreadLocal<Int?>()
    // Dernier tag reçu : après une perte, Android en fournit un nouveau via
    // onTagDiscovered et l'ancien objet est périmé (« Tag is out of date »).
    @Volatile private var latestTag: Tag? = null
    // Télémétrie : nb de passes de lecture ayant réussi (mesure l'utilité du
    // retry) et technologie du tag détecté (quels chips réussissent/échouent).
    private var lastReadAttempts = 0
    private var lastTagTech = ""
    private var lastDetectDelayMs = -1L
    // Pages Anycubic validées (numéro de page, 4 octets) avant le début de session.
    private var pagesToWrite: List<Pair<Int, ByteArray>>? = null
    private var bambuBlocksToWrite: Map<String, List<Int>>? = null

    private val coroutineScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val mainHandler = Handler(Looper.getMainLooper())
    private var timeoutRunnable: Runnable? = null
    private val SCAN_TIMEOUT_MS = 30_000L // 30 seconds timeout
    // Timeout de traitement, réarmé à la détection du tag (le timeout de scan
    // de 30 s est alors annulé) : un traitement bloqué ne laisse plus Dart sans réponse.
    private val PROCESSING_TIMEOUT_MS = 15_000L

    private var openPrintTagDataToWrite: ByteArray? = null
    private var crealityDataToWrite: Map<String, Any>? = null

    private var sessionStartTimeMs: Long = 0L
    private var tagDetectedTimeMs: Long = 0L
    private var tagWasDetected = false

    enum class NfcMode {
        IDLE,
        READ_SESSION,
        WRITE_SESSION,
        READ_BAMBU_LAB,
        WRITE_BAMBU_CLONE,
        READ_OPEN_PRINT_TAG,
        WRITE_OPEN_PRINT_TAG,
        AUTO_DETECT,
        READ_CREALITY,
        WRITE_CREALITY
    }

    init {
        nfcAdapter = NfcAdapter.getDefaultAdapter(activity)
        if (nfcAdapter == null) {
            Log.e(TAG, "NFC not available on this device")
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "Method called: ${call.method}")

        when (call.method) {
            "checkNfcAvailability" -> {
                val adapter = NfcAdapter.getDefaultAdapter(activity)
                result.success(adapter != null && adapter.isEnabled)
            }
            "startReadSession" -> startReadSession(result)
            "stopSession" -> stopSession(result)
            "startWriteSession" -> {
                val args = call.arguments as? Map<*, *>
                val rawPages = args?.get("pages") as? List<*>
                if (rawPages == null) {
                    result.error("INVALID_ARGS", "Missing pages argument", null)
                    return
                }
                // Validation de TOUTES les pages avant la session : une page non
                // convertible n'est jamais sautée en silence (avant : succès renvoyé
                // alors que SKU/marque/matériau n'étaient pas écrits).
                val pages = try {
                    parseWritePages(rawPages)
                } catch (e: IllegalArgumentException) {
                    Log.w(TAG, "startWriteSession: pages invalides — ${e.message}")
                    result.error("INVALID_ARGS", e.message ?: "Invalid pages argument", null)
                    return
                }
                startWriteSession(pages, result)
            }
            "readBambuLabTag" -> startBambuLabReadSession(result)
            "readOpenPrintTag" -> startOpenPrintTagReadSession(result)
            "startAutoDetectReadSession" -> startAutoDetectReadSession(result)
            "writeBambuLabClone" -> {
                val args = call.arguments as? Map<*, *>
                @Suppress("UNCHECKED_CAST")
                val blocks = args?.get("blocks") as? Map<String, List<Int>>
                if (blocks == null) {
                    result.error("INVALID_ARGS", "Missing blocks argument", null)
                    return
                }
                startBambuLabWriteSession(blocks, result)
            }
            "writeOpenPrintTag" -> {
                val args = call.arguments as? Map<*, *>
                @Suppress("UNCHECKED_CAST")
                val data = args?.get("data") as? List<Int>
                if (data == null) {
                    result.error("INVALID_ARGS", "Missing data argument", null)
                    return
                }
                startOpenPrintTagWriteSession(data.map { it.toByte() }.toByteArray(), result)
            }
            "readCrealityTag" -> startCrealityReadSession(result)
            "writeCrealityTag" -> {
                val args = call.arguments as? Map<*, *>
                if (args == null) {
                    result.error("INVALID_ARGS", "Missing data argument", null)
                    return
                }
                @Suppress("UNCHECKED_CAST")
                startCrealityWriteSession(args as Map<String, Any>, result)
            }
            else -> result.notImplemented()
        }
    }

    /**
     * Ouvre une nouvelle session NFC. Retourne false (après avoir déjà répondu
     * à [result]) si la session ne peut pas démarrer.
     *
     * Scan concurrent : si une session attend encore sa réponse, la NOUVELLE
     * demande est refusée avec SESSION_BUSY (l'ancienne continue). C'est le choix
     * le plus sûr : on n'interrompt jamais une écriture en cours (tag à moitié
     * écrit), et on évite qu'un SESSION_REPLACED sur l'ancienne déclenche le
     * repli auto-detect du bloc Dart, qui relancerait une session et remplacerait
     * à son tour la nouvelle (ping-pong). Aucun Future ne reste sans réponse :
     * la nouvelle reçoit SESSION_BUSY tout de suite, l'ancienne son résultat ou
     * son timeout (30 s sans tag, 15 s de traitement). Pour remplacer une
     * session, Dart appelle stopSession (USER_CANCELLED) puis relance.
     */
    private fun beginSession(result: MethodChannel.Result, mode: NfcMode): Boolean {
        if (nfcAdapter == null) {
            result.error("NFC_NOT_AVAILABLE", "NFC is not available", null)
            return false
        }

        if (!nfcAdapter!!.isEnabled) {
            result.error("NFC_DISABLED", "NFC is disabled", null)
            return false
        }

        if (pendingResult != null) {
            Log.w(TAG, "⛔ Session $sessionId encore active (mode=$currentMode) — nouvelle demande $mode refusée (SESSION_BUSY)")
            val diag = buildSessionDiagnostics().toMutableMap()
            diag["active_mode"] = currentMode.name
            diag["requested_mode"] = mode.name
            result.error("SESSION_BUSY", "Une session NFC est déjà en cours. Terminez-la ou annulez-la avant d'en démarrer une autre.", diag)
            return false
        }

        // Nouvelle session : tout traitement de la précédente devient périmé.
        currentJob?.cancel()
        currentJob = null
        cancelTimeout()
        sessionId++
        latestTag = null
        Log.d(TAG, "Session $sessionId: $mode")

        pendingResult = result
        currentMode = mode
        return true
    }

    private fun startReadSession(result: MethodChannel.Result) {
        Log.d(TAG, "Starting read session")
        if (!beginSession(result, NfcMode.READ_SESSION)) return
        enableReaderMode()
    }

    private fun startWriteSession(pages: List<Pair<Int, ByteArray>>, result: MethodChannel.Result) {
        Log.d(TAG, "Starting write session with ${pages.size} pages")
        if (!beginSession(result, NfcMode.WRITE_SESSION)) return
        pagesToWrite = pages
        enableReaderMode()
    }

    private fun startBambuLabReadSession(result: MethodChannel.Result) {
        Log.d(TAG, "Starting Bambu Lab read session")
        if (!beginSession(result, NfcMode.READ_BAMBU_LAB)) return
        enableReaderMode()
    }

    private fun startOpenPrintTagReadSession(result: MethodChannel.Result) {
        Log.d(TAG, "Starting OpenPrintTag read session")
        if (!beginSession(result, NfcMode.READ_OPEN_PRINT_TAG)) return
        enableReaderMode()
    }

    private fun startAutoDetectReadSession(result: MethodChannel.Result) {
        Log.d(TAG, "Starting auto-detect read session")
        if (!beginSession(result, NfcMode.AUTO_DETECT)) return
        enableReaderMode()
    }

    private fun startOpenPrintTagWriteSession(data: ByteArray, result: MethodChannel.Result) {
        Log.d(TAG, "Starting OpenPrintTag write session: ${data.size} bytes")
        if (!beginSession(result, NfcMode.WRITE_OPEN_PRINT_TAG)) return
        openPrintTagDataToWrite = data
        enableReaderMode()
    }

    private fun startBambuLabWriteSession(blocks: Map<String, List<Int>>, result: MethodChannel.Result) {
        Log.d(TAG, "Starting Bambu Lab write session")
        if (!beginSession(result, NfcMode.WRITE_BAMBU_CLONE)) return
        bambuBlocksToWrite = blocks
        enableReaderMode()
    }

    private fun startCrealityReadSession(result: MethodChannel.Result) {
        Log.d(TAG, "Starting Creality CFS read session")
        if (!beginSession(result, NfcMode.READ_CREALITY)) return
        enableReaderMode()
    }

    private fun startCrealityWriteSession(data: Map<String, Any>, result: MethodChannel.Result) {
        Log.d(TAG, "Starting Creality CFS write session")
        if (!beginSession(result, NfcMode.WRITE_CREALITY)) return
        crealityDataToWrite = data
        enableReaderMode()
    }

    private fun stopSession(result: MethodChannel.Result) {
        Log.d(TAG, "Stopping NFC session $sessionId")

        cancelTimeout()

        // Invalide le traitement en cours : ses réponses tardives seront ignorées.
        sessionId++
        currentJob?.cancel()
        currentJob = null

        // Notify pending result if any
        pendingResult?.error("USER_CANCELLED", "Session arrêtée", buildSessionDiagnostics())
        pendingResult = null

        // Reset state
        disableReaderMode()
        currentMode = NfcMode.IDLE
        pagesToWrite = null
        bambuBlocksToWrite = null
        openPrintTagDataToWrite = null
        crealityDataToWrite = null
        latestTag = null
        resetSessionTracking()

        result.success(true)
    }

    private var useForegroundDispatch = false

    private fun enableReaderMode() {
        startSessionTracking()
        Log.i(TAG, "🚀 NFC session start: SDK=${Build.VERSION.SDK_INT}, device=${Build.MANUFACTURER} ${Build.MODEL}, nfc_enabled=${nfcAdapter?.isEnabled}, mode=$currentMode")

        val isSamsung = Build.MANUFACTURER.equals("samsung", ignoreCase = true)

        if (isSamsung) {
            // Samsung: enableReaderMode silently fails on many models (onTagDiscovered never fires).
            // Foreground dispatch works reliably with Samsung's NFC stack.
            Log.d(TAG, "Samsung device — using foreground dispatch as primary")
            try {
                nfcAdapter?.enableForegroundDispatch(activity, foregroundDispatchIntent(), null, null)
                useForegroundDispatch = true
                startTimeout()
                Log.d(TAG, "Foreground dispatch enabled (Samsung primary)")
            } catch (e: Exception) {
                Log.e(TAG, "Foreground dispatch failed on Samsung, trying reader mode", e)
                try {
                    val flags = NfcAdapter.FLAG_READER_NFC_A or
                               NfcAdapter.FLAG_READER_NFC_B or
                               NfcAdapter.FLAG_READER_NFC_V or
                               NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK
                    val extras = android.os.Bundle()
                    extras.putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, 500)
                    nfcAdapter?.enableReaderMode(activity, this, flags, extras)
                    useForegroundDispatch = false
                    startTimeout()
                    Log.d(TAG, "Reader mode enabled as Samsung fallback (flags=$flags)")
                } catch (e2: Exception) {
                    Log.e(TAG, "Both NFC methods failed on Samsung", e2)
                    sendError("NFC_ERROR", "Cannot start NFC: ${e2.message}")
                }
            }
        } else {
            // Non-Samsung: reader mode as primary (direct callback, blocks other NFC handlers)
            try {
                // SKIP_NDEF_CHECK : sans lui, Android tente une lecture NDEF auto
                // sur chaque tag détecté, ce qui peut "perdre" les tags raw
                // (Anycubic/TigerTag) et provoquer des timeouts de détection.
                val flags = NfcAdapter.FLAG_READER_NFC_A or
                           NfcAdapter.FLAG_READER_NFC_B or
                           NfcAdapter.FLAG_READER_NFC_V or
                           NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK

                val extras = android.os.Bundle()
                extras.putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, 500)

                nfcAdapter?.enableReaderMode(activity, this, flags, extras)
                useForegroundDispatch = false
                startTimeout()
                Log.d(TAG, "Reader mode enabled as primary (flags=$flags)")
            } catch (e: Exception) {
                Log.e(TAG, "enableReaderMode failed, trying foreground dispatch", e)
                try {
                    enableForegroundDispatchFallback()
                    Log.d(TAG, "Using foreground dispatch as fallback")
                } catch (e2: Exception) {
                    Log.e(TAG, "Both NFC methods failed", e2)
                    sendError("NFC_ERROR", "Cannot start NFC: ${e2.message}")
                }
            }
        }
    }

    /** PendingIntent du foreground dispatch (renvoie l'intent NFC à MainActivity.onNewIntent). */
    private fun foregroundDispatchIntent(): PendingIntent {
        val intent = Intent(activity, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        return PendingIntent.getActivity(
            activity, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
    }

    /**
     * Appelé par MainActivity.onResume. Android coupe le foreground dispatch à
     * chaque onPause (notification, écran verrouillé, et même la remise d'un
     * intent NFC) : sur Samsung, où c'est le mode principal, la session restait
     * sourde jusqu'au timeout. On le réarme si une session est active.
     */
    fun onActivityResumed() {
        if (currentMode == NfcMode.IDLE || !useForegroundDispatch) return
        try {
            nfcAdapter?.enableForegroundDispatch(activity, foregroundDispatchIntent(), null, null)
            Log.d(TAG, "Foreground dispatch réactivé après onResume (session $sessionId, mode=$currentMode)")
        } catch (e: Exception) {
            Log.w(TAG, "Réactivation du foreground dispatch impossible: ${e.message}")
        }
    }

    /** Appelé par MainActivity.onPause : désactivation propre du foreground dispatch (exigée par Android). */
    fun onActivityPaused() {
        if (currentMode == NfcMode.IDLE || !useForegroundDispatch) return
        try {
            nfcAdapter?.disableForegroundDispatch(activity)
            Log.d(TAG, "Foreground dispatch suspendu (onPause, session $sessionId)")
        } catch (e: Exception) {
            Log.w(TAG, "disableForegroundDispatch en onPause: ${e.message}")
        }
    }

    private fun enableForegroundDispatchFallback() {
        try {
            // Pass null for filters + techList to match ALL NFC tags (most compatible)
            nfcAdapter?.enableForegroundDispatch(activity, foregroundDispatchIntent(), null, null)
            useForegroundDispatch = true
            startTimeout()
            Log.d(TAG, "Foreground dispatch enabled - waiting for any NFC tag")
        } catch (e: Exception) {
            Log.e(TAG, "enableForegroundDispatch failed", e)
            sendError("NFC_ERROR", "Cannot start NFC: ${e.message}")
        }
    }

    /** Called from MainActivity when a foreground dispatch intent is received */
    fun handleIntent(intent: Intent) {
        if (intent.action == NfcAdapter.ACTION_TECH_DISCOVERED ||
            intent.action == NfcAdapter.ACTION_TAG_DISCOVERED ||
            intent.action == NfcAdapter.ACTION_NDEF_DISCOVERED) {
            val tag: Tag? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                intent.getParcelableExtra(NfcAdapter.EXTRA_TAG, Tag::class.java)
            } else {
                @Suppress("DEPRECATION")
                intent.getParcelableExtra(NfcAdapter.EXTRA_TAG)
            }
            Log.d(TAG, "Tag received via foreground dispatch: ${tag?.techList?.joinToString()}")
            onTagDiscovered(tag)
        }
    }

    private fun disableReaderMode() {
        cancelTimeout()
        try {
            if (useForegroundDispatch) {
                nfcAdapter?.disableForegroundDispatch(activity)
                Log.d(TAG, "Foreground dispatch disabled")
            } else {
                nfcAdapter?.disableReaderMode(activity)
                Log.d(TAG, "Reader mode disabled")
            }
        } catch (e: Exception) {
            Log.w(TAG, "Error disabling NFC mode: ${e.message}")
        }
    }

    /**
     * Arme le timeout de la session courante (thread principal uniquement).
     * - [processing] = false : attente d'un tag (30 s) → TAG_NOT_DETECTED ;
     * - [processing] = true : traitement d'un tag détecté (15 s) → PROCESSING_TIMEOUT.
     */
    private fun startTimeout(timeoutMs: Long = SCAN_TIMEOUT_MS, processing: Boolean = false) {
        cancelTimeout()
        val sid = sessionId
        timeoutRunnable = Runnable {
            timeoutRunnable = null
            if (sid != sessionId) return@Runnable // session déjà terminée ou remplacée
            if (processing) {
                val diag = errorDiagnostics(mapOf("processing_timeout_ms" to timeoutMs))
                Log.w(TAG, "⏱️ NFC processing timeout after ${timeoutMs}ms — mode=$currentMode, diag=$diag")
                pendingResult?.error("PROCESSING_TIMEOUT", "Le tag a été détecté mais l'opération n'a pas abouti en ${timeoutMs / 1000}s. Gardez le tag immobile contre le téléphone et réessayez.", diag)
            } else {
                val diag = buildSessionDiagnostics()
                Log.w(TAG, "⏱️ NFC scan timeout after ${timeoutMs}ms — SDK=${Build.VERSION.SDK_INT}, device=${Build.MANUFACTURER} ${Build.MODEL}, method=${if (useForegroundDispatch) "foreground_dispatch" else "reader_mode"}, nfc_enabled=${nfcAdapter?.isEnabled}, tag_detected=$tagWasDetected, mode=$currentMode")
                pendingResult?.error("TAG_NOT_DETECTED", "Aucun tag NFC détecté après ${timeoutMs / 1000}s. Le tag est peut-être mort ou incompatible.", diag)
            }
            pendingResult = null
            // Le traitement éventuellement bloqué devient périmé : ses réponses tardives sont ignorées.
            sessionId++
            currentJob?.cancel()
            currentJob = null
            disableReaderMode()
            currentMode = NfcMode.IDLE
            pagesToWrite = null
            bambuBlocksToWrite = null
            openPrintTagDataToWrite = null
            crealityDataToWrite = null
            latestTag = null
        }
        mainHandler.postDelayed(timeoutRunnable!!, timeoutMs)
    }

    private fun cancelTimeout() {
        timeoutRunnable?.let { mainHandler.removeCallbacks(it) }
        timeoutRunnable = null
    }

    private fun buildSessionDiagnostics(): Map<String, Any> {
        val details = mutableMapOf<String, Any>(
            "tag_was_detected" to tagWasDetected,
            "sdk_version" to Build.VERSION.SDK_INT,
            "device_model" to "${Build.MANUFACTURER} ${Build.MODEL}",
            "nfc_method" to if (useForegroundDispatch) "foreground_dispatch" else "reader_mode",
            "nfc_enabled" to (nfcAdapter?.isEnabled == true),
        )
        if (sessionStartTimeMs > 0) {
            details["session_duration_ms"] = System.currentTimeMillis() - sessionStartTimeMs
        }
        if (tagDetectedTimeMs > 0 && sessionStartTimeMs > 0) {
            details["tag_detect_delay_ms"] = tagDetectedTimeMs - sessionStartTimeMs
        }
        return details
    }

    private fun startSessionTracking() {
        sessionStartTimeMs = System.currentTimeMillis()
        tagDetectedTimeMs = 0L
        tagWasDetected = false
    }

    private fun resetSessionTracking() {
        sessionStartTimeMs = 0L
        tagDetectedTimeMs = 0L
        tagWasDetected = false
    }

    override fun onTagDiscovered(tag: Tag?) {
        // Session à laquelle appartient ce tag : capturée tout de suite, toutes
        // les réponses de ce traitement seront ignorées si elle n'est plus courante.
        val sid = sessionId
        val mode = currentMode
        val detectDelay = if (sessionStartTimeMs > 0) System.currentTimeMillis() - sessionStartTimeMs else -1
        val nfcA = tag?.let { NfcA.get(it) }
        Log.i(TAG, "📡 Tag discovered: techs=[${tag?.techList?.joinToString()}], id=${tag?.id?.joinToString(":") { String.format("%02x", it) }}, SAK=${nfcA?.sak}, ATQA=${nfcA?.atqa?.joinToString(" ") { String.format("%02X", it) }}, detect_delay=${detectDelay}ms, mode=$mode, session=$sid")

        if (tag != null) latestTag = tag

        if (mode == NfcMode.IDLE) {
            Log.d(TAG, "Tag ignoré : aucune session active")
            return
        }

        // Tag reposé pendant un traitement en cours (après une perte) : on ne lance
        // pas un 2e traitement concurrent, celui en cours reprend latestTag.
        val running = currentJob
        if (tag != null && running != null && running.isActive) {
            Log.i(TAG, "Tag re-détecté pendant le traitement (session $sid) — latestTag mis à jour, pas de nouveau traitement")
            return
        }

        // Télémétrie : technologie du tag (sans le préfixe android.nfc.tech.) + reset attempts.
        lastTagTech = tag?.techList?.joinToString(",") { it.substringAfterLast('.') } ?: ""
        lastDetectDelayMs = detectDelay
        lastReadAttempts = 0
        tagWasDetected = true
        tagDetectedTimeMs = System.currentTimeMillis()

        if (tag == null) {
            sendError("NO_TAG", "No tag detected", forSession = sid)
            return
        }

        // Detect NFC-V (ISO 15693) tags - e.g. Prusa OpenPrintTag
        val nfcV = NfcV.get(tag)
        if (nfcV != null && mode != NfcMode.READ_OPEN_PRINT_TAG && mode != NfcMode.AUTO_DETECT && mode != NfcMode.WRITE_OPEN_PRINT_TAG) {
            val techList = tag.techList.joinToString(", ")
            val tagId = tag.id?.joinToString(":") { String.format("%02x", it) } ?: "unknown"
            Log.w(TAG, "📡 NFC-V (ISO 15693) tag detected - ID: $tagId, techs: $techList")
            sendError("INCOMPATIBLE_TAG",
                "Tag NFC détecté mais de type ISO 15693 (NFC-V). Ce type est utilisé par Prusa (OpenPrintTag) et n'est pas encore supporté dans ce mode. Sélectionnez le mode Prusa.",
                forSession = sid)
            return
        }

        // Anycubic = NTAG213/215 (Type 2). Un MIFARE Classic ou un tag IsoDep
        // (Type 4) partait dans ~12 s de lectures NfcA vouées à l'échec : on
        // répond tout de suite.
        if (mode == NfcMode.READ_SESSION || mode == NfcMode.WRITE_SESSION) {
            val techs = tag.techList
            val incompatibleType = when {
                techs.contains(MifareClassic::class.java.name) -> "MifareClassic"
                techs.contains(IsoDep::class.java.name) -> "IsoDep"
                else -> null
            }
            if (incompatibleType != null) {
                Log.w(TAG, "📡 Tag $incompatibleType en mode Anycubic ($mode) — INCOMPATIBLE_TAG immédiat")
                val action = if (mode == NfcMode.WRITE_SESSION) "écrire" else "lire"
                val hint = if (incompatibleType == "MifareClassic")
                    "Les tags MIFARE Classic sont utilisés par Bambu Lab et Creality : sélectionnez le mode correspondant ou la détection automatique."
                else
                    "Ce tag ISO 14443-4 (IsoDep) n'est pas un tag de bobine Anycubic."
                sendError("INCOMPATIBLE_TAG",
                    "Tag $incompatibleType détecté : impossible de le $action en mode Anycubic (NTAG213/215 requis). $hint",
                    mapOf("tag_type" to incompatibleType),
                    forSession = sid)
                return
            }
        }

        // Le timeout de scan (30 s) est remplacé par un timeout de traitement
        // (15 s) : un traitement bloqué (repli, tag muet) répond quand même.
        mainHandler.post {
            if (sid == sessionId && currentMode != NfcMode.IDLE) {
                startTimeout(PROCESSING_TIMEOUT_MS, processing = true)
            }
        }

        currentJob = coroutineScope.launch(handlerSessionId.asContextElement(sid)) {
            try {
                when (mode) {
                    NfcMode.READ_SESSION -> handleReadSession(tag)
                    NfcMode.WRITE_SESSION -> handleWriteSession(tag)
                    NfcMode.READ_BAMBU_LAB -> handleBambuLabRead(tag)
                    NfcMode.WRITE_BAMBU_CLONE -> handleBambuLabWrite(tag)
                    NfcMode.READ_OPEN_PRINT_TAG -> handleOpenPrintTagRead(tag)
                    NfcMode.WRITE_OPEN_PRINT_TAG -> handleOpenPrintTagWrite(tag)
                    NfcMode.AUTO_DETECT -> handleAutoDetectRead(tag)
                    NfcMode.READ_CREALITY -> handleCrealityRead(tag)
                    NfcMode.WRITE_CREALITY -> handleCrealityWrite(tag)
                    NfcMode.IDLE -> { /* Do nothing */ }
                }
            } catch (e: CancellationException) {
                Log.d(TAG, "Traitement de la session $sid annulé")
            } catch (e: Exception) {
                Log.e(TAG, "Error processing tag", e)
                sendError("TAG_ERROR", e.message ?: "Unknown error")
            } finally {
                // NonCancellable : le nettoyage s'exécute même si le job a été annulé,
                // mais seulement si la session est toujours la courante.
                withContext(NonCancellable + Dispatchers.Main) {
                    if (sid == sessionId) {
                        disableReaderMode()
                        currentMode = NfcMode.IDLE
                        currentJob = null
                        // Données d'écriture effacées ici (et non dans les handlers) :
                        // un traitement périmé ne peut plus vider celles de la session suivante.
                        pagesToWrite = null
                        bambuBlocksToWrite = null
                        openPrintTagDataToWrite = null
                        crealityDataToWrite = null
                    } else {
                        Log.d(TAG, "Fin du traitement de la session $sid (courante=$sessionId) — reader mode laissé intact")
                    }
                }
            }
        }
    }

    // ==================== READ SESSION (MiFare Ultralight) ====================

    private suspend fun handleReadSession(tag: Tag) {
        Log.d(TAG, "Handling read session")

        // Try MiFare Ultralight first (Anycubic/NTAG)
        if (MifareUltralight.get(tag) != null) {
            readAnycubicTag(tag, useUltralight = true, tagType = null)
            return
        }

        // Fallback to NfcA for generic reading
        if (NfcA.get(tag) != null) {
            readAnycubicTag(tag, useUltralight = false, tagType = null)
            return
        }

        sendError("INVALID_TAG", "Tag not supported")
    }

    /** Résultat brut d'une lecture d'un tag Type 2 (Ultralight/NTAG), pages 0-39 au moins. */
    private class Type2ReadResult(
        val data: ByteArray,          // octets lus, dans l'ordre, depuis la page 0
        val attempts: Int,            // passes de lecture utilisées
        val lastError: Exception?,    // dernière exception rencontrée
        val connectFailed: Boolean,   // les 3 tentatives de connexion initiale ont échoué
        val requiredBytes: Int = ANYCUBIC_READ_BYTES // octets attendus (plus si message NDEF long)
    )

    /** Échec des [CONNECT_ATTEMPTS] tentatives de connexion (le tag a bougé ou est parti). */
    private class ConnectFailedException(message: String, cause: Exception) : IOException(message, cause)

    /**
     * Lit un tag Anycubic (pages 0-39) et répond à Dart. Une lecture doit faire
     * 160 octets : 0 octet → TAG_MOVED (perte du tag) ou EMPTY_READ, lecture
     * incomplète → PARTIAL_READ (avant : renvoyée comme un succès tronqué).
     * [tagType] est ajouté au résultat quand il est non null (Bambu / auto-detect).
     */
    private suspend fun readAnycubicTag(tag: Tag, useUltralight: Boolean, tagType: String?) {
        val label = if (useUltralight) "MiFare Ultralight" else "NfcA"
        val read = try {
            readType2Pages(tag, useUltralight)
        } catch (e: CancellationException) {
            throw e
        } catch (e: Exception) {
            Log.e(TAG, "Error reading $label", e)
            if (isTagLost(e)) {
                sendTagMoved("Le tag a été perdu pendant la lecture.", mapOf("last_exception" to describe(e)))
            } else {
                sendError("READ_ERROR", e.message ?: "Read failed", mapOf("last_exception" to describe(e)))
            }
            return
        }
        lastReadAttempts = read.attempts
        val readData = read.data
        val bytesRead = readData.size
        val diag = mutableMapOf<String, Any>("bytes_read" to bytesRead)
        read.lastError?.let { diag["last_exception"] = describe(it) }

        when {
            read.connectFailed -> {
                diag["connect_attempts"] = CONNECT_ATTEMPTS
                sendTagMoved("Connexion au tag impossible après $CONNECT_ATTEMPTS tentatives.", diag)
            }
            bytesRead == 0 && isTagLost(read.lastError) ->
                sendTagMoved("Le tag a été perdu avant la lecture de la première page.", diag)
            bytesRead == 0 ->
                sendError("EMPTY_READ", "Impossible de lire le tag (0 octet). Maintenez le tag immobile contre le téléphone et réessayez.", diag)
            bytesRead < read.requiredBytes -> {
                // Préfixe « Tag was lost » si c'est une perte : le Dart affiche alors
                // « reposez le tag sans bouger » au lieu d'une erreur générique.
                val cause = if (isTagLost(read.lastError)) "$TAG_LOST_HINT — le tag a bougé. " else ""
                diag["required_bytes"] = read.requiredBytes
                sendError("PARTIAL_READ", "${cause}Lecture incomplète ($bytesRead/${read.requiredBytes} octets) après ${read.attempts} passe(s). Maintenez le tag immobile contre le téléphone et réessayez.", diag)
            }
            else -> {
                val resultData = mutableMapOf<String, Any>(
                    "data" to readData.decodeToStringOrEmpty(),
                    "rawBytes" to readData.map { it.toInt() and 0xFF },
                    "read_attempts" to lastReadAttempts,
                    "tag_tech" to lastTagTech,
                    "detect_delay_ms" to lastDetectDelayMs
                )
                if (tagType != null) resultData["tagType"] = tagType
                sendSuccess(resultData)
            }
        }
    }

    /**
     * Lit les pages 0-39 d'un tag Type 2 avec retry.
     * Deux niveaux de robustesse, chacun avec le tag le PLUS RÉCENT (après une
     * perte, Android fournit un nouvel objet Tag ; l'ancien est périmé et ne
     * rendait que des « 0 octet ») :
     *  - par page : sur exception, reconnexion + nouvel essai de la page ;
     *  - par passe : si la passe s'arrête avant la fin, nouvelle passe qui REPREND
     *    à la page en échec (les pages déjà lues sont gardées), jusqu'à
     *    READ_ATTEMPTS passes. Corrige les lectures « 0 bytes » / tronquées
     *    observées sur Samsung/A55 quand le tag bouge légèrement pendant la lecture.
     * MifareUltralight lit 4 pages par commande ; NfcA reste page par page.
     */
    private suspend fun readType2Pages(tag: Tag, useUltralight: Boolean): Type2ReadResult {
        val pagesPerRead = if (useUltralight) 4 else 1
        // +4 pages : une commande MifareUltralight lit toujours 4 pages.
        val buffer = ByteArray((TYPE2_MAX_PAGES + 4) * 4)
        var targetPages = ANYCUBIC_PAGES
        var extensionChecked = false
        var nextPage = 0
        var lastError: Exception? = null

        var conn: TagTechnology = try {
            connectType2(tag, useUltralight)
        } catch (e: ConnectFailedException) {
            return Type2ReadResult(ByteArray(0), 0, e.cause as? Exception ?: e, connectFailed = true)
        }
        Log.d(TAG, "Connected via ${if (useUltralight) "MiFare Ultralight" else "NfcA"}")

        var attempt = 0
        try {
            while (nextPage < targetPages && attempt < READ_ATTEMPTS) {
                attempt++
                if (attempt > 1) {
                    Log.w(TAG, "Full-read attempt ${attempt - 1} stopped at ${nextPage * 4}/${targetPages * 4} bytes — reconnecting (latest tag), resuming at page $nextPage")
                    conn = try {
                        reconnectType2(conn, tag, useUltralight)
                    } catch (e: ConnectFailedException) {
                        lastError = e.cause as? Exception ?: e
                        break
                    }
                }
                pass@ while (nextPage < targetPages) {
                    val chunk = try {
                        readType2Chunk(conn, nextPage, pagesPerRead)
                    } catch (e: Exception) {
                        // Exception (pas juste IOException) : couvre IllegalStateException
                        // "Call connect() first!" et SecurityException "Tag ... is out of date".
                        lastError = e
                        Log.w(TAG, "Read pages $nextPage failed: ${describe(e)} — reconnecting for retry")
                        conn = try {
                            reconnectType2(conn, tag, useUltralight)
                        } catch (e2: ConnectFailedException) {
                            lastError = e2.cause as? Exception ?: e2
                            break@pass
                        }
                        try {
                            readType2Chunk(conn, nextPage, pagesPerRead)
                        } catch (e2: Exception) {
                            lastError = e2
                            Log.w(TAG, "Retry failed for page $nextPage: ${describe(e2)}")
                            break@pass
                        }
                    }
                    System.arraycopy(chunk, 0, buffer, nextPage * 4, pagesPerRead * 4)
                    Log.d(TAG, "Read pages $nextPage-${nextPage + pagesPerRead - 1}: ${chunk.copyOf(pagesPerRead * 4).toHexString()}")
                    nextPage += pagesPerRead
                    if (!extensionChecked && nextPage >= ANYCUBIC_PAGES) {
                        extensionChecked = true
                        type2NdefEndPage(buffer, nextPage * 4)?.let { end ->
                            if (end > targetPages) {
                                Log.d(TAG, "NDEF message ends at page $end — extending read")
                                targetPages = end
                            }
                        }
                    }
                }
            }
        } finally {
            try { conn.close() } catch (_: Exception) {}
        }
        return Type2ReadResult(
            buffer.copyOf(nextPage * 4), attempt, lastError,
            connectFailed = false, requiredBytes = targetPages * 4
        )
    }

    /**
     * Fin (page exclue) du message NDEF d'un tag Type 2 : TLV 0x03 dès la page 4,
     * plafonnée par la capacité du Capability Container (page 3) et NTAG216.
     * Null si la page 4 n'est pas du NDEF (tag Anycubic : 0x7B) : seuls les TLV
     * NULL / Lock / Memory Control (0x00-0x02) peuvent précéder le NDEF.
     */
    private fun type2NdefEndPage(buf: ByteArray, have: Int): Int? {
        if (have < 20 || (buf[12].toInt() and 0xFF) != 0xE1) return null
        val capacityPages = 4 + (buf[14].toInt() and 0xFF) * 2 // MLEN × 8 octets = × 2 pages
        var offset = 16
        while (offset + 1 < have) {
            val type = buf[offset].toInt() and 0xFF
            if (type == 0x00) { offset++; continue }
            if (type !in 0x01..0x03) return null
            var length = buf[offset + 1].toInt() and 0xFF
            var valueStart = offset + 2
            if (length == 0xFF) {
                if (offset + 3 >= have) return null
                length = ((buf[offset + 2].toInt() and 0xFF) shl 8) or (buf[offset + 3].toInt() and 0xFF)
                valueStart = offset + 4
            }
            if (type == 0x03) {
                return minOf((valueStart + length + 3) / 4, capacityPages, TYPE2_MAX_PAGES)
            }
            offset = valueStart + length
        }
        return null
    }

    /** Lit [pagesPerRead] page(s) à partir de [page] (commande READ 0x30) ; lève une IOException si la réponse est trop courte. */
    private fun readType2Chunk(conn: TagTechnology, page: Int, pagesPerRead: Int): ByteArray {
        val response = when (conn) {
            is MifareUltralight -> conn.readPages(page)
            is NfcA -> conn.transceive(byteArrayOf(CMD_READ, page.toByte()))
            else -> throw IOException("Technologie non supportée : ${conn.javaClass.simpleName}")
        }
        val expected = pagesPerRead * 4
        if (response == null || response.size < expected) {
            throw IOException("Réponse trop courte page $page (${response?.size ?: 0}/$expected octets)")
        }
        return response
    }

    /** Connexion Type 2 (3 tentatives, tag le plus récent) avec timeout de 2 s. */
    private suspend fun connectType2(tag: Tag, useUltralight: Boolean): TagTechnology =
        if (useUltralight) {
            connectWithRetry(tag, "MiFare Ultralight", { MifareUltralight.get(it) }) { it.timeout = 2000 }
        } else {
            connectWithRetry(tag, "NfcA", { NfcA.get(it) }) { it.timeout = 2000 }
        }

    /** Ferme la connexion courante puis se reconnecte avec le tag le plus récent. */
    private suspend fun reconnectType2(old: TagTechnology, tag: Tag, useUltralight: Boolean): TagTechnology {
        try { old.close() } catch (_: Exception) {}
        delay(50)
        return connectType2(tag, useUltralight)
    }

    /**
     * Connexion avec [CONNECT_ATTEMPTS] tentatives espacées de [CONNECT_RETRY_DELAY_MS].
     * À chaque tentative, la technologie est recréée depuis le tag le plus récent
     * (même UID) : connect() peut lever une IOException sans message juste après
     * la détection, et un ancien objet Tag est périmé après une perte.
     * Lève [ConnectFailedException] (cause = dernière exception) si tout échoue.
     */
    private suspend fun <T : TagTechnology> connectWithRetry(
        tag: Tag,
        label: String,
        open: (Tag) -> T?,
        configure: (T) -> Unit
    ): T {
        var lastError: Exception = IOException("$label indisponible pour ce tag")
        for (attempt in 1..CONNECT_ATTEMPTS) {
            val tech = open(freshTag(tag)) ?: open(tag)
            if (tech != null) {
                try {
                    tech.connect()
                    configure(tech)
                    if (attempt > 1) Log.i(TAG, "$label connecté à la tentative $attempt/$CONNECT_ATTEMPTS")
                    return tech
                } catch (e: Exception) {
                    lastError = e
                    Log.w(TAG, "$label connect() tentative $attempt/$CONNECT_ATTEMPTS échouée: ${describe(e)}")
                    try { tech.close() } catch (_: Exception) {}
                }
            }
            if (attempt < CONNECT_ATTEMPTS) delay(CONNECT_RETRY_DELAY_MS)
        }
        throw ConnectFailedException("$label: connexion impossible après $CONNECT_ATTEMPTS tentatives (${describe(lastError)})", lastError)
    }

    // ==================== WRITE SESSION (MiFare Ultralight) ====================

    private suspend fun handleWriteSession(tag: Tag) {
        Log.d(TAG, "Handling write session")

        val pages = pagesToWrite
        if (pages == null || pages.isEmpty()) {
            sendError("INVALID_ARGS", "No pages to write")
            return
        }

        if (MifareUltralight.get(tag) != null) {
            writeMifareUltralight(tag, pages)
            return
        }

        // Fallback to NfcA
        if (NfcA.get(tag) != null) {
            writeWithNfcA(tag, pages)
            return
        }

        sendError("INVALID_TAG", "Tag not supported for writing")
    }

    /**
     * Valide et convertit les pages reçues de Dart, AVANT toute écriture.
     * Les octets arrivent en ByteArray (Uint8List → byte[], ex. utf8.encode du
     * SKU) ou en List de nombres (littéral Dart) : avant, le cast `as? List<Number>`
     * échouait sur ByteArray et la page était sautée en silence avec un succès
     * renvoyé. Toute page invalide lève IllegalArgumentException (→ INVALID_ARGS).
     */
    private fun parseWritePages(rawPages: List<*>): List<Pair<Int, ByteArray>> {
        require(rawPages.isNotEmpty()) { "Aucune page à écrire" }
        return rawPages.mapIndexed { index, entry ->
            val pageInfo = entry as? Map<*, *>
                ?: throw IllegalArgumentException("Entrée $index invalide (Map attendue, reçu ${entry?.javaClass?.simpleName})")
            val pageNumber = (pageInfo["page"] as? Number)?.toInt()
                ?: throw IllegalArgumentException("Entrée $index : numéro de page manquant ou invalide (${pageInfo["page"]})")
            require(pageNumber in 0..255) { "Page $pageNumber hors limites" }
            val rawData = pageInfo["data"]
            val data = dartBytes(rawData)
                ?: throw IllegalArgumentException("Page $pageNumber : données non convertibles en octets (${rawData?.javaClass?.simpleName ?: "null"})")
            require(data.size == 4) { "Page $pageNumber : ${data.size} octets au lieu de 4" }
            pageNumber to data
        }
    }

    /** Octets reçus de Dart : Uint8List arrive en ByteArray, List<int> en List de nombres. null sinon. */
    private fun dartBytes(raw: Any?): ByteArray? = when (raw) {
        is ByteArray -> raw
        is List<*> -> if (raw.all { it is Number }) ByteArray(raw.size) { i -> (raw[i] as Number).toByte() } else null
        else -> null
    }

    private suspend fun writeMifareUltralight(tag: Tag, pages: List<Pair<Int, ByteArray>>) {
        val maxRetries = 2
        for (attempt in 1..maxRetries) {
            // Tag le plus récent (même UID) : après une perte, l'ancien objet est périmé.
            val mifare = MifareUltralight.get(freshTag(tag)) ?: MifareUltralight.get(tag)
            if (mifare == null) {
                sendError("INVALID_TAG", "Tag not supported for writing")
                return
            }
            try {
                mifare.connect()
                mifare.timeout = 5000 // 5s timeout for foldable devices
                Log.d(TAG, "Connected to MiFare Ultralight for writing (attempt $attempt/$maxRetries)")

                for ((pageNumber, data) in pages) {
                    try {
                        mifare.writePage(pageNumber, data)
                        Log.d(TAG, "Written page $pageNumber: ${data.toHexString()}")
                    } catch (e: IOException) {
                        Log.e(TAG, "Error writing page $pageNumber", e)
                        throw e
                    }
                }

                mifare.close()
                sendSuccess(true)
                return // Success, exit

            } catch (e: Exception) {
                Log.e(TAG, "Error writing MiFare Ultralight (attempt $attempt/$maxRetries)", e)
                try { mifare.close() } catch (_: Exception) {}

                if (attempt < maxRetries) {
                    Log.d(TAG, "Retrying write in 300ms...")
                    delay(300)
                } else {
                    sendError("WRITE_ERROR", "Tag perdu pendant l'écriture. Gardez le tag bien appuyé contre l'arrière de l'appareil et réessayez.")
                }
            }
        }
    }

    private suspend fun writeWithNfcA(tag: Tag, pages: List<Pair<Int, ByteArray>>) {
        val maxRetries = 2
        for (attempt in 1..maxRetries) {
            // Tag le plus récent (même UID) : après une perte, l'ancien objet est périmé.
            val nfcA = NfcA.get(freshTag(tag)) ?: NfcA.get(tag)
            if (nfcA == null) {
                sendError("INVALID_TAG", "Tag not supported for writing")
                return
            }
            try {
                nfcA.connect()
                nfcA.timeout = 5000 // 5s timeout for foldable devices
                Log.d(TAG, "Connected via NfcA for writing (attempt $attempt/$maxRetries)")

                for ((pageNumber, data) in pages) {
                    // WRITE command: 0xA2 + page + 4 bytes
                    val command = byteArrayOf(CMD_WRITE_ULTRALIGHT, pageNumber.toByte()) + data

                    try {
                        nfcA.transceive(command)
                        Log.d(TAG, "Written page $pageNumber: ${data.toHexString()}")
                    } catch (e: IOException) {
                        Log.e(TAG, "Error writing page $pageNumber", e)
                        throw e
                    }
                }

                nfcA.close()
                sendSuccess(true)
                return // Success, exit

            } catch (e: Exception) {
                Log.e(TAG, "Error writing with NfcA (attempt $attempt/$maxRetries)", e)
                try { nfcA.close() } catch (_: Exception) {}

                if (attempt < maxRetries) {
                    Log.d(TAG, "Retrying write in 300ms...")
                    delay(300)
                } else {
                    sendError("WRITE_ERROR", "Tag perdu pendant l'écriture. Gardez le tag bien appuyé contre l'arrière de l'appareil et réessayez.")
                }
            }
        }
    }

    // ==================== BAMBU LAB READ (MiFare Classic) ====================

    private suspend fun handleBambuLabRead(tag: Tag) {
        Log.d(TAG, "Handling Bambu Lab read")

        // Check tag type for auto-detection
        val techList = tag.techList

        // Try MiFare Classic first (Bambu Lab tags)
        if (techList.contains(MifareClassic::class.java.name)) {
            val classic = MifareClassic.get(tag)
            if (classic != null) {
                readMifareClassic(classic)
                return
            }
        }

        // If MiFare Ultralight, read as Anycubic and return with tagType
        if (techList.contains(MifareUltralight::class.java.name)) {
            if (MifareUltralight.get(tag) != null) {
                readAnycubicTag(tag, useUltralight = true, tagType = "ultralight")
                return
            }
        }

        // Fallback to NfcA with auto-detection
        val nfcA = NfcA.get(tag)
        if (nfcA != null) {
            // Try to determine tag type from SAK
            val sak = nfcA.sak
            Log.d(TAG, "Tag SAK: $sak")

            // SAK 0x00 = MiFare Ultralight
            // SAK 0x08 = MiFare Classic 1K
            // SAK 0x18 = MiFare Classic 4K
            when {
                sak.toInt() == 0x00 -> readAnycubicTag(tag, useUltralight = false, tagType = "ultralight")
                sak.toInt() == 0x08 || sak.toInt() == 0x18 -> sendMifareClassicUnsupported()
                else -> readAnycubicTag(tag, useUltralight = false, tagType = "unknown")
            }
            return
        }

        sendError("INVALID_TAG", "Tag not supported")
    }

    /**
     * MIFARE Classic détecté (SAK 0x08/0x18) mais MifareClassic.get() == null :
     * la puce NFC du téléphone ne gère pas Crypto1. L'ancien repli NfcA envoyait
     * l'authentification en clair (sans effet) puis renvoyait un succès vide
     * (bobine fantôme) ou bloquait sans timeout : on répond tout de suite.
     */
    private fun sendMifareClassicUnsupported() {
        Log.w(TAG, "MIFARE Classic détecté mais non supporté par ce téléphone (MifareClassic.get == null)")
        sendError("INCOMPATIBLE_TAG",
            "MIFARE Classic non supporté par ce téléphone : sa puce NFC ne gère pas l'authentification MIFARE Classic (tags Bambu Lab et Creality).",
            mapOf("tag_type" to "MifareClassic", "mifare_classic_supported" to false))
    }

    // ==================== BAMBU LAB HKDF KEY DERIVATION ====================

    private fun hmacSha256(key: ByteArray, data: ByteArray): ByteArray {
        val mac = Mac.getInstance("HmacSHA256")
        mac.init(SecretKeySpec(key, "HmacSHA256"))
        return mac.doFinal(data)
    }

    private fun hkdfExtract(salt: ByteArray, ikm: ByteArray): ByteArray {
        return hmacSha256(salt, ikm)
    }

    private fun hkdfExpand(prk: ByteArray, info: ByteArray, length: Int): ByteArray {
        val hashLen = 32 // SHA-256
        val n = (length + hashLen - 1) / hashLen
        val okm = ByteArray(n * hashLen)
        var t = byteArrayOf() // T(0) is empty

        for (i in 1..n) {
            val input = t + info + byteArrayOf(i.toByte())
            t = hmacSha256(prk, input)
            System.arraycopy(t, 0, okm, (i - 1) * hashLen, hashLen)
        }
        return okm.copyOf(length)
    }

    /** Derive 16 MiFare Classic Key-A values (6 bytes each) from tag UID */
    private fun deriveBambuKeys(uid: ByteArray): List<ByteArray> {
        val prk = hkdfExtract(BAMBU_HKDF_SALT, uid)
        val okm = hkdfExpand(prk, BAMBU_HKDF_INFO, 6 * 16) // 96 bytes
        return (0 until 16).map { i -> okm.copyOfRange(i * 6, i * 6 + 6) }
    }

    // ==================== BAMBU LAB READ (MiFare Classic) ====================

    /**
     * Authentifie un secteur Bambu : clé A dérivée (HKDF), puis clé par défaut
     * (A puis B, clones CUID). authenticateSectorWith*() renvoie false sur une
     * mauvaise clé (sans exception) : avant, un « false » sur la clé dérivée
     * n'essayait jamais les clés par défaut.
     */
    private fun authenticateBambuSector(classic: MifareClassic, sector: Int, derivedKey: ByteArray?): Boolean {
        val attempts = mutableListOf<Pair<String, () -> Boolean>>()
        if (derivedKey != null) {
            attempts.add("HKDF Key A" to { classic.authenticateSectorWithKeyA(sector, derivedKey) })
        }
        attempts.add("default Key A" to { classic.authenticateSectorWithKeyA(sector, DEFAULT_KEY) })
        attempts.add("default Key B" to { classic.authenticateSectorWithKeyB(sector, DEFAULT_KEY) })
        for ((label, authenticate) in attempts) {
            try {
                if (authenticate()) return true
                Log.d(TAG, "$label refused for sector $sector")
            } catch (e: Exception) {
                Log.d(TAG, "$label failed for sector $sector: ${describe(e)}")
            }
        }
        Log.w(TAG, "All keys failed for sector $sector")
        return false
    }

    /**
     * Lecture Bambu Lab (mode Bambu et auto-détection, mêmes clés dérivées).
     * Sans bloc 5 (secteur 1 inaccessible), répond AUTH_ERROR : avant, un
     * succès avec rawBlocks vide devenait une bobine fantôme « PLA blanc 1000 g ».
     * [tagType] est ajouté au résultat quand il est non null (auto-détection).
     */
    private suspend fun readMifareClassic(classic: MifareClassic, tagType: String? = null) {
        try {
            classic.connect()
            classic.timeout = 5000 // Extended timeout for budget NFC controllers
            delay(100) // RF field stabilization
            val uid = classic.tag.id
            val derivedKeys = deriveBambuKeys(uid)
            Log.d(TAG, "Connected to MiFare Classic, UID: ${uid.toHexString()}")
            Log.d(TAG, "Type: ${classic.type}, Size: ${classic.size}, Sectors: ${classic.sectorCount}")

            val blockData = mutableMapOf<Int, ByteArray>()
            var authenticatedSectors = 0

            // Read all sectors (16 sectors for 1K)
            for (sector in 0 until classic.sectorCount) {
                // Try HKDF-derived key first, then fallback to default
                if (!authenticateBambuSector(classic, sector, derivedKeys.getOrNull(sector))) {
                    Log.w(TAG, "Could not authenticate sector $sector")
                    continue
                }
                authenticatedSectors++

                // Read blocks in this sector (skip sector trailer)
                val firstBlock = classic.sectorToBlock(sector)
                val blockCount = classic.getBlockCountInSector(sector)

                for (i in 0 until blockCount - 1) { // Skip last block (sector trailer)
                    val blockIndex = firstBlock + i
                    try {
                        val data = classic.readBlock(blockIndex)
                        if (data != null) {
                            blockData[blockIndex] = data
                            Log.d(TAG, "Read block $blockIndex: ${data.toHexString()}")
                        }
                    } catch (e: IOException) {
                        Log.w(TAG, "Error reading block $blockIndex: ${e.message}")
                    }
                }
            }

            classic.close()

            // Aucun bloc utile (bloc 5 = matériau/températures) : échec explicite.
            if (blockData[5] == null) {
                Log.w(TAG, "MiFare Classic: block 5 unreadable ($authenticatedSectors/${classic.sectorCount} sectors authenticated) — AUTH_ERROR")
                sendError("AUTH_ERROR",
                    "Impossible de lire les données de la bobine (secteur 1 inaccessible). Ce tag n'est pas une bobine Bambu Lab lisible, ou il a bougé : gardez-le bien appuyé et réessayez.",
                    mapOf(
                        "uid" to uid.toHexString(),
                        "sectors_authenticated" to authenticatedSectors,
                        "sector_count" to classic.sectorCount,
                        "blocks_read" to blockData.size,
                        "tag_type" to "MifareClassic"
                    ))
                return
            }

            // Parse Bambu Lab data
            val parsedData = parseBambuLabData(blockData).toMutableMap()
            if (tagType != null) parsedData["tagType"] = tagType
            sendSuccess(parsedData)

        } catch (e: Exception) {
            Log.e(TAG, "Error reading MiFare Classic", e)
            try { classic.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
    }

    /**
     * Blocs bruts seulement : le décodage (format officiel RFID-Tag-Guide) est
     * fait côté Dart par BambuTagParser, testé sur des dumps réels. L'ancien
     * décodage ici lisait le bloc 5 comme matériau/températures et le bloc 6
     * comme couleur : tout était faux.
     */
    private fun parseBambuLabData(blockData: Map<Int, ByteArray>): Map<String, Any> {
        val rawBlocks = mutableMapOf<String, List<Int>>()
        for ((blockNum, data) in blockData) {
            rawBlocks["block_$blockNum"] = data.map { it.toInt() and 0xFF }
        }
        return mapOf("rawBlocks" to rawBlocks)
    }

    // ==================== OPEN PRINT TAG READ (ISO 15693 / NFC-V) ====================

    private suspend fun handleOpenPrintTagRead(tag: Tag) {
        Log.d(TAG, "Handling OpenPrintTag read")
        readOpenPrintTag(tag, tagType = null)
    }

    /** Réponse ISO 15693 avec le bit d'erreur (octet 0, bit 0) : refus du tag, pas une perte. */
    private class Iso15693StatusException(message: String) : IOException(message)

    /** Lecture ISO 15693 interrompue avant la fin du message NDEF. */
    private class NfcVReadException(
        message: String,
        val bytesRead: Int,
        val bytesExpected: Int, // -1 si la longueur NDEF n'était pas encore connue
        val failedBlock: Int,
        cause: Exception?
    ) : IOException(message, cause)

    /** Lecture OpenPrintTag commune au mode Prusa et à l'auto-détection ([tagType] ajouté si non null). */
    private fun readOpenPrintTag(tag: Tag, tagType: String?) {
        val nfcV = NfcV.get(tag)
        if (nfcV == null) {
            sendError("INVALID_TAG", "Tag is not ISO 15693 (NFC-V)")
            return
        }

        try {
            nfcV.connect()
            Log.d(TAG, "Connected to NFC-V tag")

            val data = try {
                readOpenPrintTagBytes(nfcV)
            } finally {
                try { nfcV.close() } catch (_: Exception) {}
            }

            Log.d(TAG, "OpenPrintTag: ${data.size} bytes read")

            val resultData = mutableMapOf<String, Any>("rawBytes" to data.map { it.toInt() and 0xFF })
            if (tagType != null) resultData["tagType"] = tagType

            sendSuccess(resultData)

        } catch (e: NfcVReadException) {
            // Erreur avant la fin du message NDEF : échec, plus de succès partiel.
            Log.w(TAG, "OpenPrintTag partial read: ${e.message}")
            val diag = mutableMapOf<String, Any>("bytes_read" to e.bytesRead, "failed_block" to e.failedBlock)
            if (e.bytesExpected >= 0) diag["bytes_expected"] = e.bytesExpected
            e.cause?.let { diag["last_exception"] = describe(it) }
            val lostHint = if (isTagLost(e.cause)) "$TAG_LOST_HINT — le tag a bougé. " else ""
            val total = if (e.bytesExpected >= 0) "/${e.bytesExpected}" else ""
            sendError("PARTIAL_READ",
                "${lostHint}Lecture Prusa incomplète (${e.bytesRead}$total octets, échec au bloc ${e.failedBlock}). Maintenez le tag immobile contre le téléphone et réessayez.",
                diag)
        } catch (e: Exception) {
            Log.e(TAG, "Error reading NFC-V tag", e)
            try { nfcV.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
    }

    /**
     * Lit un tag OpenPrintTag depuis le bloc 0 : CC (4 octets, ou 8 si MLEN = 0),
     * puis les TLV jusqu'au TLV NDEF 0x03, dont la longueur fixe exactement les
     * blocs à lire. Avant : arrêt sur le premier 0xFE trouvé n'importe où (un
     * octet de données valait « terminateur »), plafond de 64 blocs (un SLIX2 en
     * compte 80) et une erreur en cours de route donnait un succès partiel.
     * Sans CC NDEF ni TLV 0x03 (tag vierge / non formaté), renvoie l'en-tête lu :
     * le Dart signale alors « format non identifié », comme avant.
     * Lève [NfcVReadException] si un bloc nécessaire ne peut pas être lu.
     */
    private fun readOpenPrintTagBytes(nfcV: NfcV): ByteArray {
        val bytes = mutableListOf<Byte>()
        var nextBlock = 0
        var expected = -1

        // ISO 15693 Read Single Block : flags 0x02 (high data rate), commande 0x20.
        // Réponse : octet 0 = flags (bit 0 = erreur, octet 1 = code), puis données.
        fun readBlock(block: Int): ByteArray {
            var lastError: IOException? = null
            for (attempt in 1..2) { // 1 essai + 1 nouvel essai (tag qui bouge)
                try {
                    val response = nfcV.transceive(byteArrayOf(0x02, 0x20, block.toByte()))
                    if (response == null || response.isEmpty()) throw IOException("Réponse vide (bloc $block)")
                    if ((response[0].toInt() and 0x01) != 0) {
                        val code = if (response.size >= 2) String.format("0x%02X", response[1]) else "?"
                        throw Iso15693StatusException("Erreur ISO 15693 $code (bloc $block)")
                    }
                    if (response.size < 2) throw IOException("Réponse sans données (bloc $block)")
                    return response.copyOfRange(1, response.size)
                } catch (e: IOException) {
                    lastError = e
                    Log.w(TAG, "NFC-V read block $block attempt $attempt/2 failed: ${describe(e)}")
                }
            }
            throw lastError ?: IOException("Lecture du bloc $block impossible")
        }

        fun u8(index: Int): Int = bytes[index].toInt() and 0xFF

        // Lit des blocs jusqu'à disposer d'au moins [count] octets.
        fun ensure(count: Int) {
            while (bytes.size < count) {
                if (nextBlock >= NFCV_MAX_BLOCKS) {
                    throw NfcVReadException("Longueur NDEF ($count octets) au-delà des $NFCV_MAX_BLOCKS blocs adressables", bytes.size, expected, nextBlock, null)
                }
                val data = try {
                    readBlock(nextBlock)
                } catch (e: IOException) {
                    throw NfcVReadException("Lecture interrompue au bloc $nextBlock (${bytes.size} octets lus)", bytes.size, expected, nextBlock, e)
                }
                bytes.addAll(data.toList())
                Log.d(TAG, "Block $nextBlock: ${data.joinToString(" ") { String.format("%02x", it) }}")
                nextBlock++
            }
        }

        // 1. Capability Container
        ensure(4)
        val magic = u8(0)
        if (magic != 0xE1 && magic != 0xE2) {
            Log.w(TAG, String.format("OpenPrintTag: no NDEF capability container (magic=0x%02X)", magic))
            return bytes.toByteArray()
        }
        val ccLength = if (u8(2) == 0) 8 else 4

        // 2. TLV jusqu'au message NDEF (type 0x03)
        var offset = ccLength
        while (true) {
            ensure(offset + 1)
            val type = u8(offset)
            if (type == 0x00) { // NULL TLV
                offset++
                continue
            }
            if (type == 0xFE) { // Terminator avant tout message NDEF
                Log.w(TAG, "OpenPrintTag: terminator TLV at offset $offset, no NDEF message")
                return bytes.toByteArray()
            }
            ensure(offset + 2)
            var length = u8(offset + 1)
            var headerSize = 2
            if (length == 0xFF) { // longueur sur 3 octets (0xFF + 2 octets big-endian)
                ensure(offset + 4)
                length = (u8(offset + 2) shl 8) or u8(offset + 3)
                headerSize = 4
            }
            val end = offset + headerSize + length
            if (type == 0x03) {
                expected = end
                Log.d(TAG, "OpenPrintTag: NDEF TLV at offset $offset, $length bytes → reading up to byte $end")
                ensure(end)
                return bytes.toByteArray()
            }
            offset = end // TLV Lock/Memory control/propriétaire : on le saute
        }
    }

    // ==================== OPEN PRINT TAG WRITE (ISO 15693 / NFC-V) ====================

    private suspend fun handleOpenPrintTagWrite(tag: Tag) {
        Log.d(TAG, "Handling OpenPrintTag write")

        val data = openPrintTagDataToWrite
        if (data == null || data.isEmpty()) {
            sendError("INVALID_ARGS", "No data to write")
            return
        }

        val nfcV = NfcV.get(tag)
        if (nfcV == null) {
            sendError("INVALID_TAG", "Tag is not ISO 15693 (NFC-V). Use an NXP ICODE SLIX2 tag.")
            return
        }

        try {
            nfcV.connect()
            Log.d(TAG, "Connected to NFC-V tag for writing")

            // Write data in 4-byte blocks
            val totalBlocks = (data.size + 3) / 4
            Log.d(TAG, "Writing $totalBlocks blocks (${data.size} bytes)")

            for (blockNum in 0 until totalBlocks) {
                val offset = blockNum * 4
                val blockData = ByteArray(4)
                for (i in 0 until 4) {
                    blockData[i] = if (offset + i < data.size) data[offset + i] else 0x00
                }

                // ISO 15693 Write Single Block command
                // Flags: 0x02 (high data rate)
                // Command: 0x21 (WRITE_SINGLE_BLOCK)
                // Block number
                // Data: 4 bytes
                val cmd = byteArrayOf(0x02, 0x21, blockNum.toByte()) + blockData
                val response = nfcV.transceive(cmd)
                // Octet 0 = flags, bit 0 = erreur (octet 1 = code). Avant, la réponse
                // était ignorée : bloc verrouillé ou hors mémoire → succès renvoyé.
                if (response == null || response.isEmpty() || (response[0].toInt() and 0x01) != 0) {
                    val isoError = if (response != null && response.size >= 2) String.format("0x%02X", response[1]) else "réponse vide"
                    throw Iso15693StatusException("Écriture refusée au bloc $blockNum (erreur ISO 15693 $isoError, $blockNum/$totalBlocks blocs écrits). Le tag est peut-être verrouillé ou trop petit.")
                }

                Log.d(TAG, "Written block $blockNum: ${blockData.joinToString(" ") { String.format("%02X", it) }}")
            }

            nfcV.close()
            Log.d(TAG, "OpenPrintTag write complete: $totalBlocks blocks written")
            sendSuccess(true)

        } catch (e: Exception) {
            Log.e(TAG, "Error writing NFC-V tag", e)
            try { nfcV.close() } catch (_: Exception) {}
            sendError("WRITE_ERROR", e.message ?: "Write failed")
        }
    }

    // ==================== AUTO-DETECT READ ====================

    private suspend fun handleAutoDetectRead(tag: Tag) {
        Log.d(TAG, "Handling auto-detect read")

        // 1. Check for NFC-V (ISO 15693) - Prusa OpenPrintTag
        val nfcV = NfcV.get(tag)
        if (nfcV != null) {
            Log.d(TAG, "Auto-detect: NFC-V (Prusa) tag detected")
            handleOpenPrintTagReadWithTagType(tag)
            return
        }

        // 2. Check for MiFare Classic - try Creality first, then Bambu Lab
        val techList = tag.techList
        if (techList.contains(MifareClassic::class.java.name)) {
            val classic = MifareClassic.get(tag)
            if (classic != null) {
                Log.d(TAG, "Auto-detect: MiFare Classic tag detected, trying Creality then Bambu Lab")

                // Try Creality CFS first (fast XOR key derivation + vendor check)
                // Use retry for weak NFC controllers (e.g. Samsung budget phones)
                val crealityResult = tryCrealityDetectionWithRetry(tag)
                if (crealityResult != null) {
                    sendSuccess(crealityResult)
                    return
                }

                // Not Creality, try Bambu Lab (reconnect needed after failed auth).
                // Mêmes clés dérivées que le mode Bambu (avant : clé par défaut seule).
                val classic2 = MifareClassic.get(freshTag(tag))
                if (classic2 != null) {
                    Log.d(TAG, "Auto-detect: Trying Bambu Lab")
                    readMifareClassic(classic2, "bambu")
                    return
                }
            }
        }

        // 3. Check for MiFare Ultralight - Anycubic
        if (techList.contains(MifareUltralight::class.java.name)) {
            if (MifareUltralight.get(tag) != null) {
                Log.d(TAG, "Auto-detect: MiFare Ultralight (Anycubic) tag detected")
                readAnycubicTag(tag, useUltralight = true, tagType = "anycubic")
                return
            }
        }

        // 4. Fallback to NfcA with SAK-based detection
        val nfcA = NfcA.get(tag)
        if (nfcA != null) {
            val sak = nfcA.sak
            Log.d(TAG, "Auto-detect: NfcA tag, SAK=$sak")
            when {
                sak.toInt() == 0x00 -> readAnycubicTag(tag, useUltralight = false, tagType = "anycubic")
                sak.toInt() == 0x08 || sak.toInt() == 0x18 -> sendMifareClassicUnsupported()
                else -> readAnycubicTag(tag, useUltralight = false, tagType = "anycubic")
            }
            return
        }

        sendError("INVALID_TAG", "Tag not supported")
    }

    private suspend fun handleOpenPrintTagReadWithTagType(tag: Tag) {
        Log.d(TAG, "Handling OpenPrintTag read (auto-detect)")
        readOpenPrintTag(tag, tagType = "prusa")
    }

    // ==================== BAMBU LAB WRITE (CUID Cards) ====================

    private suspend fun handleBambuLabWrite(tag: Tag) {
        Log.d(TAG, "Handling Bambu Lab write")

        val blocks = bambuBlocksToWrite
        if (blocks == null || blocks.isEmpty()) {
            sendError("INVALID_ARGS", "No blocks to write")
            return
        }

        // Try MiFare Classic
        val classic = MifareClassic.get(tag)
        if (classic != null) {
            writeMifareClassic(classic, blocks)
            return
        }

        // Pas de MifareClassic : un repli NfcA ne peut pas authentifier (Crypto1).
        val sak = NfcA.get(tag)?.sak?.toInt()
        if (sak == 0x08 || sak == 0x18) {
            sendMifareClassicUnsupported()
            return
        }

        sendError("INVALID_TAG", "Tag not supported for Bambu Lab cloning")
    }

    private suspend fun writeMifareClassic(classic: MifareClassic, blocks: Map<String, List<Int>>) {
        try {
            classic.connect()
            classic.timeout = 5000 // Extended timeout for budget NFC controllers
            delay(100) // RF field stabilization
            Log.d(TAG, "Connected to MiFare Classic for writing")

            // Sort block numbers
            val sortedBlocks = blocks.entries
                .mapNotNull { (key, value) ->
                    val blockNum = key.removePrefix("block_").toIntOrNull()
                    if (blockNum != null) blockNum to value else null
                }
                .sortedBy { it.first }

            for ((blockNumber, dataList) in sortedBlocks) {
                // Skip sector trailers
                if (blockNumber % 4 == 3) {
                    Log.d(TAG, "Skipping sector trailer block $blockNumber")
                    continue
                }

                val sector = blockNumber / 4

                // Authenticate
                val authSuccess = try {
                    classic.authenticateSectorWithKeyA(sector, DEFAULT_KEY)
                } catch (e: Exception) {
                    try {
                        classic.authenticateSectorWithKeyB(sector, DEFAULT_KEY)
                    } catch (e2: Exception) {
                        false
                    }
                }

                if (!authSuccess) {
                    Log.e(TAG, "Cannot authenticate sector $sector")
                    throw IOException("Authentication failed for sector $sector")
                }

                // Prepare data (pad to 16 bytes)
                val data = ByteArray(16)
                for (i in 0 until minOf(dataList.size, 16)) {
                    data[i] = dataList[i].toByte()
                }

                // Write block
                classic.writeBlock(blockNumber, data)
                Log.d(TAG, "Written block $blockNumber: ${data.toHexString()}")
            }

            classic.close()
            sendSuccess(true)

        } catch (e: Exception) {
            Log.e(TAG, "Error writing MiFare Classic", e)
            try { classic.close() } catch (_: Exception) {}
            sendError("WRITE_ERROR", e.message ?: "Write failed")
        }
    }

    // ==================== CREALITY CFS KEY DERIVATION ====================

    /**
     * Derive Sector 1 Key B from tag UID using AES-ECB encryption.
     * Algorithm (from CFSWriter / community reverse-engineering):
     * 1. UID (4 bytes) → uppercase hex string (8 chars)
     * 2. Repeat 4x → 32 hex chars
     * 3. Convert hex string to 16 raw bytes
     * 4. AES-128-ECB encrypt with CREALITY_UID_KEY
     * 5. Take first 6 bytes as Key B
     */
    private fun deriveCrealityKey(uid: ByteArray): ByteArray {
        val uidHex = uid.take(4).joinToString("") { String.format("%02X", it) }
        val repeated = uidHex.repeat(4).take(32) // 32 hex chars
        // Convert hex string to 16 raw bytes (not ASCII bytes!)
        val plaintext = ByteArray(16) { i ->
            repeated.substring(i * 2, i * 2 + 2).toInt(16).toByte()
        }

        val cipher = Cipher.getInstance("AES/ECB/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, SecretKeySpec(CREALITY_UID_KEY, "AES"))
        val encrypted = cipher.doFinal(plaintext)

        return encrypted.copyOfRange(0, 6) // Key B = first 6 bytes
    }

    // ==================== CREALITY CFS AES-128-ECB ====================

    private fun aesEcbDecrypt(data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("AES/ECB/NoPadding")
        cipher.init(Cipher.DECRYPT_MODE, SecretKeySpec(CREALITY_AES_KEY, "AES"))
        return cipher.doFinal(data)
    }

    private fun aesEcbEncrypt(data: ByteArray): ByteArray {
        val cipher = Cipher.getInstance("AES/ECB/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, SecretKeySpec(CREALITY_AES_KEY, "AES"))
        return cipher.doFinal(data)
    }

    // ==================== CREALITY CFS READ ====================

    private suspend fun handleCrealityRead(tag: Tag) {
        Log.d(TAG, "Handling Creality CFS read")

        val classic = MifareClassic.get(tag)
        if (classic != null) {
            readCrealityClassic(classic)
            return
        }

        // MIFARE Classic (SAK 0x08/0x18) sans MifareClassic : l'ancien repli NfcA
        // ne pouvait pas authentifier (Crypto1) → réponse immédiate.
        val sak = NfcA.get(tag)?.sak?.toInt()
        if (sak == 0x08 || sak == 0x18) {
            sendMifareClassicUnsupported()
            return
        }

        sendError("INVALID_TAG", "Tag non compatible Creality CFS (MiFare Classic 1K requis)")
    }

    /** Clé ayant ouvert le secteur 1 d'un tag Creality. */
    private enum class CrealityKey { DERIVED_A, DERIVED_B, DEFAULT_A, DEFAULT_B }

    /**
     * Ouvre le secteur 1 d'un tag Creality CFS. Sur les vraies bobines, la clé
     * dérivée de l'UID est la clé A (clé B = FFFFFFFFFFFF), comme dans K2-RFID
     * et OpenRFID ; avant, elle n'était essayée qu'en clé B. Ordre : dérivée A,
     * dérivée B, défaut A (tag vierge), défaut B — chaque essai sur une
     * connexion neuve (un échec d'authentification fige l'état MIFARE).
     */
    private suspend fun authenticateCrealitySector(tag: Tag, derivedKey: ByteArray): Pair<MifareClassic, CrealityKey>? {
        val uid = tag.id
        Log.i(TAG, "🔐 Creality auth start: UID=${uid.toHexString()}, techs=[${tag.techList.joinToString(", ")}]")
        val attempts = listOf(
            CrealityKey.DERIVED_A to { m: MifareClassic -> m.authenticateSectorWithKeyA(1, derivedKey) },
            CrealityKey.DERIVED_B to { m: MifareClassic -> m.authenticateSectorWithKeyB(1, derivedKey) },
            CrealityKey.DEFAULT_A to { m: MifareClassic -> m.authenticateSectorWithKeyA(1, DEFAULT_KEY) },
            CrealityKey.DEFAULT_B to { m: MifareClassic -> m.authenticateSectorWithKeyB(1, DEFAULT_KEY) },
        )
        for ((key, authenticate) in attempts) {
            val mfc = MifareClassic.get(tag)
            if (mfc == null) {
                Log.e(TAG, "🔐 Creality auth: MifareClassic.get() returned null")
                return null
            }
            try {
                mfc.connect()
                mfc.timeout = 5000
                delay(100) // stabilisation du champ RF (contrôleurs NFC faibles)
                if (authenticate(mfc)) {
                    Log.d(TAG, "🔐 Creality sector 1 opened with $key")
                    return mfc to key
                }
                Log.d(TAG, "🔐 Creality $key refused")
            } catch (e: Exception) {
                Log.w(TAG, "🔐 Creality $key exception: ${e::class.simpleName}: ${e.message}")
            }
            try { mfc.close() } catch (_: Exception) {}
        }
        Log.e(TAG, "🔐 Creality: all keys failed for UID=${uid.toHexString()}, device=${Build.MANUFACTURER} ${Build.MODEL}")
        return null
    }

    /**
     * Disposition du texte clair (48 caractères) d'un tag Creality :
     * - REAL : vraies bobines et K2-RFID — Date(5) | Vendor(4) | Lot(2) |
     *   ID filament(6, « 1 » + matériau) | Couleur(7) | Longueur(4) | Série(6) | Réservé(14) ;
     * - LEGACY : tags écrits par l'app jusqu'à la 1.4.10+92 — Lot(3) | Date(5) |
     *   Vendor(4) | Matériau(5) | puis mêmes champs.
     * Null si le vendor « 0276 » n'est à aucune des deux places.
     * Avant (1.4.10+87 à +92) : vendor attendu à 8-11 seulement → toute vraie
     * bobine refusée (« ce n'est pas une bobine Creality »).
     */
    private enum class CrealityLayout { REAL, LEGACY }

    private fun crealityLayout(decrypted: String): CrealityLayout? = when {
        decrypted.length >= 9 && decrypted.substring(5, 9) == CREALITY_VENDOR -> CrealityLayout.REAL
        decrypted.length >= 12 && decrypted.substring(8, 12) == CREALITY_VENDOR -> CrealityLayout.LEGACY
        else -> null
    }

    /** Lit et déchiffre les blocs 4-6 (secteur 1 déjà ouvert). Lève une IOException si un bloc manque. */
    private fun readCrealityPlaintext(mfc: MifareClassic): String {
        val encryptedData = ByteArray(48)
        for (i in 0 until 3) {
            val blockIndex = 4 + i
            val data = mfc.readBlock(blockIndex)
            // Bloc manquant = échec (nouvel essai), pas des zéros déchiffrés en données.
            if (data == null || data.size < 16) throw IOException("Creality block $blockIndex unreadable (${data?.size ?: 0} bytes)")
            System.arraycopy(data, 0, encryptedData, i * 16, 16)
        }
        return String(aesEcbDecrypt(encryptedData), Charsets.US_ASCII)
    }

    private suspend fun readCrealityClassic(classic: MifareClassic) {
        val maxRetries = 3
        val tag = classic.tag
        val uid = tag.id
        val derivedKey = deriveCrealityKey(uid)
        Log.d(TAG, "Creality: UID=${uid.toHexString()}, derived key=${derivedKey.toHexString()}")

        for (attempt in 1..maxRetries) {
            try {
                Log.d(TAG, "Creality read attempt $attempt/$maxRetries")
                // Tag le plus récent (même UID) : après une perte, l'ancien objet est périmé.
                val opened = authenticateCrealitySector(freshTag(tag), derivedKey)

                if (opened == null) {
                    if (attempt < maxRetries) {
                        Log.d(TAG, "Creality auth failed attempt $attempt/$maxRetries, retrying in 300ms...")
                        delay(300)
                        continue
                    }
                    val diag = buildSessionDiagnostics().toMutableMap()
                    diag["uid"] = uid.toHexString()
                    diag["retries_exhausted"] = maxRetries
                    sendError("AUTH_ERROR", "Impossible d'authentifier le tag Creality CFS (secteur 1). Gardez le tag bien appuyé et réessayez.", diag)
                    return
                }
                val (mfc, key) = opened

                try {
                    val decryptedStr = readCrealityPlaintext(mfc)
                    mfc.close()
                    Log.d(TAG, "Creality decrypted ($key): $decryptedStr")

                    // Vendor « 0276 » obligatoire : un MIFARE Classic vierge ou d'une autre
                    // marque (clés par défaut) donnait une bobine fantôme « 1000 g ».
                    if (crealityLayout(decryptedStr) == null) {
                        val printable = decryptedStr.take(12).filter { it in ' '..'~' }
                        Log.w(TAG, "Creality: vendor $CREALITY_VENDOR absent ('$printable') — INCOMPATIBLE_TAG")
                        sendError("INCOMPATIBLE_TAG",
                            "Tag MIFARE Classic lu, mais ce n'est pas une bobine Creality CFS (vendor « $CREALITY_VENDOR » absent).",
                            mapOf("tag_type" to "MifareClassic", "header" to printable, "uid" to uid.toHexString(), "key" to key.name))
                        return
                    }

                    sendSuccess(parseCrealityData(decryptedStr, uid))
                    return // Success
                } catch (e: Exception) {
                    try { mfc.close() } catch (_: Exception) {}
                    throw e // Re-throw to outer catch for retry
                }

            } catch (e: Exception) {
                Log.e(TAG, "Error reading Creality CFS (attempt $attempt/$maxRetries)", e)

                if (attempt < maxRetries) {
                    Log.d(TAG, "Retrying Creality read in 300ms...")
                    delay(300)
                } else {
                    sendError("READ_ERROR", "Échec lecture Creality après $maxRetries tentatives. Gardez le tag bien appuyé et réessayez.")
                }
            }
        }
    }

    // ==================== CREALITY CFS PARSE ====================

    private fun parseCrealityData(decrypted: String, uid: ByteArray): Map<String, Any> {
        Log.d(TAG, "Parsing Creality data: '$decrypted' (${decrypted.length} chars)")
        fun part(from: Int, to: Int) = if (decrypted.length >= to) decrypted.substring(from, to) else ""

        val legacy = crealityLayout(decrypted) == CrealityLayout.LEGACY
        val batch = if (legacy) part(0, 3) else part(9, 11)
        val date = if (legacy) part(3, 8) else part(0, 5)
        val vendor = if (legacy) part(8, 12) else part(5, 9)
        // Matériau : 5 derniers chiffres de l'ID filament (« 1 » + matériau) dans
        // la disposition réelle, champ à 12-17 dans l'ancienne : même position.
        val materialId = part(12, 17)
        val colorField = part(17, 24)
        val lengthCode = part(24, 28)
        val serial = part(28, 34)

        // Parse color RGB (format: "0RRGGBB")
        val colorRgb = try {
            if (colorField.length >= 7) {
                Integer.parseInt(colorField.substring(1, 7), 16)
            } else 0xFFFFFF
        } catch (e: NumberFormatException) {
            0xFFFFFF
        }

        // Parse weight from length code
        val weightGrams = crealityWeightCodes[lengthCode] ?: 1000.0

        // Date. Mois sur 1 caractère hexadécimal (1-9, A-C = octobre-décembre).
        // Réelle (K2-RFID) : M | JJ | AA ; ancienne (écrite par l'app) : AA | M | JJ.
        // Champ non conforme (ex. « 9C625 » d'usine) → pas de date plutôt qu'une fausse.
        val productionTimestamp = try {
            if (date.length >= 5) {
                val (yy, m, dd) = if (legacy) Triple(date.substring(0, 2), date.substring(2, 3), date.substring(3, 5))
                                  else Triple(date.substring(3, 5), date.substring(0, 1), date.substring(1, 3))
                val month = m.toInt(16)
                val day = dd.toInt()
                require(month in 1..12 && day in 1..31) { "date invalide : $date" }
                java.util.Calendar.getInstance().apply {
                    set(2000 + yy.toInt(), month - 1, day)
                }.timeInMillis / 1000
            } else 0L
        } catch (e: Exception) { 0L }

        // Material name lookup
        val materialName = crealityMaterials[materialId] ?: "Unknown ($materialId)"

        return mapOf(
            "tagType" to "creality",
            "vendor" to vendor,
            "materialId" to materialId,
            "materialName" to materialName,
            "colorRgb" to colorRgb,
            "weightGrams" to weightGrams.toInt(),
            "batch" to batch,
            "serial" to serial,
            "productionTimestamp" to productionTimestamp,
            "lengthCode" to lengthCode,
            "uid" to uid.joinToString("") { String.format("%02X", it) },
            "rawDecrypted" to decrypted
        )
    }

    // ==================== CREALITY CFS WRITE ====================

    private suspend fun handleCrealityWrite(tag: Tag) {
        Log.d(TAG, "Handling Creality CFS write")

        val data = crealityDataToWrite
        if (data == null) {
            sendError("INVALID_ARGS", "No Creality data to write")
            return
        }

        val classic = MifareClassic.get(tag)
        if (classic != null) {
            writeCrealityClassic(classic, data)
            return
        }

        // MIFARE Classic sans support du téléphone : message explicite.
        val sak = NfcA.get(tag)?.sak?.toInt()
        if (sak == 0x08 || sak == 0x18) {
            sendMifareClassicUnsupported()
            return
        }

        sendError("INVALID_TAG", "Tag non compatible pour l'ecriture Creality CFS (MiFare Classic 1K requis)")
    }

    /**
     * Écrit un tag Creality CFS comme K2-RFID (référence de la communauté) :
     * texte clair dans la disposition réelle, chiffré AES, blocs 4-6. Sur un
     * tag vierge (ouvert avec la clé A par défaut), les clés A et B du secteur 1
     * deviennent la clé dérivée de l'UID, bits d'accès inchangés : c'est cette
     * clé que l'imprimante utilise. Avant : ancienne disposition et clés par
     * défaut laissées en place → tag illisible pour une imprimante CFS.
     */
    private suspend fun writeCrealityClassic(classic: MifareClassic, data: Map<String, Any>) {
        val maxRetries = 3
        val tag = classic.tag
        val uid = tag.id
        val derivedKey = deriveCrealityKey(uid)
        Log.d(TAG, "Creality write: UID=${uid.toHexString()}")

        // Build 48-char payload (only once, doesn't change between retries)
        val payload = buildCrealityPayload(data)
        Log.d(TAG, "Creality payload: $payload")
        val encrypted = aesEcbEncrypt(payload.toByteArray(Charsets.US_ASCII))

        for (attempt in 1..maxRetries) {
            try {
                Log.d(TAG, "Creality write attempt $attempt/$maxRetries")
                // Tag le plus récent (même UID) : après une perte, l'ancien objet est périmé.
                val opened = authenticateCrealitySector(freshTag(tag), derivedKey)

                if (opened == null) {
                    if (attempt < maxRetries) {
                        Log.d(TAG, "Creality write auth failed attempt $attempt/$maxRetries, retrying in 300ms...")
                        delay(300)
                        continue
                    }
                    sendError("AUTH_ERROR", "Impossible d'authentifier le tag pour écriture Creality CFS. Gardez le tag bien appuyé et réessayez.")
                    return
                }
                val (mfc, key) = opened

                try {
                    // Write blocks 4, 5, 6
                    for (i in 0 until 3) {
                        val blockIndex = 4 + i
                        val blockData = encrypted.copyOfRange(i * 16, (i + 1) * 16)
                        mfc.writeBlock(blockIndex, blockData)
                        Log.d(TAG, "Creality written block $blockIndex: ${blockData.toHexString()}")
                    }

                    // Tag vierge : clés du secteur 1 → clé dérivée (A octets 0-5, B
                    // octets 10-15), bits d'accès (6-9) relus et conservés, comme K2-RFID.
                    if (key == CrealityKey.DEFAULT_A) {
                        val trailer = mfc.readBlock(7)
                        if (trailer != null && trailer.size >= 16) {
                            System.arraycopy(derivedKey, 0, trailer, 0, 6)
                            System.arraycopy(derivedKey, 0, trailer, 10, 6)
                            mfc.writeBlock(7, trailer)
                            Log.d(TAG, "Creality sector 1 keys set to derived key (access bits kept)")
                        }
                    }

                    mfc.close()
                    sendSuccess(true)
                    return // Success
                } catch (e: Exception) {
                    try { mfc.close() } catch (_: Exception) {}
                    throw e
                }

            } catch (e: Exception) {
                Log.e(TAG, "Error writing Creality CFS (attempt $attempt/$maxRetries)", e)

                if (attempt < maxRetries) {
                    Log.d(TAG, "Retrying Creality write in 300ms...")
                    delay(300)
                } else {
                    sendError("WRITE_ERROR", "Échec écriture Creality après $maxRetries tentatives. Gardez le tag bien appuyé et réessayez.")
                }
            }
        }
    }

    /**
     * Texte clair de 48 caractères, disposition réelle (K2-RFID) : Date(5,
     * M hexadécimal | JJ | AA) | Vendor(4) | Lot(2) | « 1 » + matériau(5) |
     * « 0 » + RGB(6) | Longueur(4) | Série(6) | Réservé(14).
     */
    private fun buildCrealityPayload(data: Map<String, Any>): String {
        val now = java.util.Calendar.getInstance()
        val month = (now.get(java.util.Calendar.MONTH) + 1).toString(16).uppercase()
        val day = now.get(java.util.Calendar.DAY_OF_MONTH).toString().padStart(2, '0')
        val year = (now.get(java.util.Calendar.YEAR) % 100).toString().padStart(2, '0')
        val date = "$month$day$year"

        val vendor = (data["vendor"] as? String ?: CREALITY_VENDOR).padEnd(4, '0').take(4)
        val batch = (data["batch"] as? String)?.filter { it.isLetterOrDigit() }?.take(2)?.padEnd(2, '0') ?: "A2"
        val materialId = (data["materialId"] as? String ?: "04001").padEnd(5, '0').take(5)

        // Color: "0" + 6-char RGB hex
        val colorRgb = (data["colorRgb"] as? Int) ?: 0xFFFFFF
        val colorField = "0${String.format("%06X", colorRgb and 0xFFFFFF)}"

        val lengthCode = (data["lengthCode"] as? String ?: "0330").padEnd(4, '0').take(4)
        val serial = (data["serial"] as? String ?: "000001").padEnd(6, '0').take(6)
        val reserved = "00000000000000" // 14 chars

        val payload = "$date$vendor${batch}1$materialId$colorField$lengthCode$serial$reserved"
        Log.d(TAG, "Built Creality payload: $payload (${payload.length} chars)")
        return payload.take(48).padEnd(48, '0')
    }

    // ==================== CREALITY CFS AUTO-DETECT ====================

    /**
     * Identifie un MIFARE Classic comme bobine Creality CFS (2 essais : utile
     * sur les contrôleurs NFC faibles, ex. Samsung SM-A217F). Clé dérivée en A
     * puis en B (avant : B seulement, alors que c'est la clé A des vraies
     * bobines → jamais reconnues, lues ensuite comme des tags Bambu Lab).
     * Retourne les données décodées, ou null si ce n'est pas un Creality.
     */
    private suspend fun tryCrealityDetectionWithRetry(tag: Tag): Map<String, Any>? {
        val uid = tag.id
        val derivedKey = deriveCrealityKey(uid)

        for (attempt in 1..2) {
            for (useKeyA in listOf(true, false)) {
                // Tag le plus récent (même UID) : après une perte, l'ancien objet est périmé.
                val mfc = MifareClassic.get(freshTag(tag)) ?: return null
                try {
                    mfc.connect()
                    mfc.timeout = 5000
                    delay(100) // RF field stabilization
                    val authSuccess = try {
                        if (useKeyA) mfc.authenticateSectorWithKeyA(1, derivedKey)
                        else mfc.authenticateSectorWithKeyB(1, derivedKey)
                    } catch (e: Exception) {
                        Log.d(TAG, "Auto-detect: Creality derived key ${if (useKeyA) "A" else "B"} failed (attempt $attempt): ${e.message}")
                        false
                    }
                    if (!authSuccess) {
                        mfc.close()
                        continue
                    }

                    val decryptedStr = readCrealityPlaintext(mfc)
                    mfc.close()
                    return if (crealityLayout(decryptedStr) != null) {
                        Log.d(TAG, "Auto-detect: Creality CFS confirmed (attempt $attempt)")
                        parseCrealityData(decryptedStr, uid)
                    } else {
                        Log.d(TAG, "Auto-detect: Creality key OK but vendor absent, not Creality")
                        null
                    }
                } catch (e: Exception) {
                    Log.d(TAG, "Auto-detect: Creality detection failed (attempt $attempt): ${e.message}")
                    try { mfc.close() } catch (_: Exception) {}
                }
            }
            if (attempt < 2) delay(200)
        }
        return null
    }

    // Creality material database (instance-level to avoid companion object conflict)
    private val crealityMaterials = mapOf(
        "00001" to "Generic PLA", "01001" to "Hyper PLA", "02001" to "PLA Matte",
        "03001" to "PLA Silk", "04001" to "CR-PLA", "05001" to "PLA HS",
        "06001" to "CR-PETG", "07001" to "Hyper PETG", "08001" to "Generic PETG",
        "09001" to "PETG-CF", "10001" to "CR-ABS", "11001" to "Hyper ABS",
        "12001" to "Generic ABS", "13001" to "ABS-GF", "14001" to "TPU",
        "15001" to "PA", "16001" to "CR-TPU", "17001" to "ASA",
        "18001" to "PVA", "19001" to "HIPS", "20001" to "PC",
        "21001" to "BVOH", "22001" to "PET"
    )

    private val crealityWeightCodes = mapOf(
        "0330" to 1000.0, "0165" to 500.0, "0082" to 250.0,
        "0198" to 600.0, "0247" to 750.0
    )

    // ==================== HELPERS ====================

    /**
     * Session de l'appelant : celle du traitement en cours sur ce thread
     * (coroutine lancée par onTagDiscovered), sinon la session courante
     * (appel direct depuis le thread principal, ex. enableReaderMode).
     */
    private fun callerSessionId(): Int = handlerSessionId.get() ?: sessionId

    private fun sendSuccess(data: Any, forSession: Int = callerSessionId()) {
        activity.runOnUiThread {
            if (forSession != sessionId) {
                Log.w(TAG, "sendSuccess ignoré : session $forSession terminée (courante=$sessionId)")
                return@runOnUiThread
            }
            pendingResult?.success(data)
            pendingResult = null
        }
    }

    /** Diagnostics d'erreur : session + télémétrie du tag + [extraDiagnostics]. */
    private fun errorDiagnostics(extraDiagnostics: Map<String, Any>? = null): MutableMap<String, Any> {
        val diagnostics = buildSessionDiagnostics().toMutableMap()
        // Télémétrie du tag aussi en cas d'échec (avant : succès seulement →
        // les « 0 octet » / « Read failed » arrivaient sans tag_tech ni essais).
        if (tagWasDetected) {
            diagnostics["read_attempts"] = lastReadAttempts
            if (lastTagTech.isNotEmpty()) diagnostics["tag_tech"] = lastTagTech
            if (lastDetectDelayMs >= 0) diagnostics["detect_delay_ms"] = lastDetectDelayMs
        }
        extraDiagnostics?.let { diagnostics.putAll(it) }
        return diagnostics
    }

    private fun sendError(
        code: String,
        message: String,
        extraDiagnostics: Map<String, Any>? = null,
        forSession: Int = callerSessionId()
    ) {
        val diagnostics = errorDiagnostics(extraDiagnostics)
        Log.w(TAG, "📤 sendError: code=$code, msg=$message, diag=$diagnostics")
        activity.runOnUiThread {
            // Session terminée ou remplacée : ne rien faire (ni réponse, ni arrêt
            // du reader mode, qui appartient désormais à la session suivante).
            if (forSession != sessionId) {
                Log.w(TAG, "sendError $code ignoré : session $forSession terminée (courante=$sessionId)")
                return@runOnUiThread
            }
            pendingResult?.error(code, message, diagnostics)
            pendingResult = null
            disableReaderMode()
            currentMode = NfcMode.IDLE
        }
    }

    /**
     * TAG_MOVED : le tag a été perdu (TagLostException, IOException, « out of
     * date »). Le message commence par [TAG_LOST_HINT], reconnu par le Dart pour
     * afficher « reposez le tag sans bouger ».
     */
    private fun sendTagMoved(detail: String, extraDiagnostics: Map<String, Any>? = null) {
        sendError("TAG_MOVED", "$TAG_LOST_HINT — $detail Reposez le tag contre le téléphone sans bouger et réessayez.", extraDiagnostics)
    }

    /** Perte du tag : TagLostException, IOException (hors refus ISO 15693) ou SecurityException « out of date ». */
    private fun isTagLost(e: Throwable?): Boolean = when (e) {
        null -> false
        is Iso15693StatusException -> false
        is TagLostException -> true
        is IOException -> true
        is SecurityException -> e.message?.contains("out of date", ignoreCase = true) == true
        else -> false
    }

    /**
     * Tag le plus récent fourni par Android pour la MÊME puce (même UID), sinon
     * [original]. Un UID différent (autre bobine posée) n'est jamais utilisé :
     * on ne mélange pas les pages de deux tags.
     */
    private fun freshTag(original: Tag): Tag {
        val latest = latestTag ?: return original
        if (latest === original) return original
        return if (latest.id.contentEquals(original.id)) {
            latest
        } else {
            Log.w(TAG, "latestTag ignoré : UID différent (${latest.id.toHexString()} ≠ ${original.id.toHexString()})")
            original
        }
    }

    private fun describe(e: Throwable): String = "${e.javaClass.simpleName}: ${e.message}"

    private fun ByteArray.toHexString(): String {
        return joinToString(" ") { String.format("%02X", it) }
    }

    private fun ByteArray.decodeToStringOrEmpty(): String {
        return try {
            // Filter printable ASCII characters
            String(this.filter { it.toInt() and 0xFF in 32..126 }.toByteArray(), Charsets.US_ASCII)
        } catch (e: Exception) {
            ""
        }
    }

    fun cleanup() {
        coroutineScope.cancel()
        disableReaderMode()
    }
}
