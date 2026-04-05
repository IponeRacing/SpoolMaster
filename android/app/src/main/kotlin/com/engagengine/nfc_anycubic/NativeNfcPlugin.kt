package com.engagengine.nfc_anycubic

import android.app.Activity
import android.app.PendingIntent
import android.content.Intent
import android.content.IntentFilter
import android.nfc.NfcAdapter
import android.nfc.Tag
import android.nfc.tech.MifareClassic
import android.nfc.tech.MifareUltralight
import android.nfc.tech.NfcA
import android.nfc.tech.NfcV
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.IOException
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

/**
 * Native NFC Plugin for Android
 * Implements Method Channel: com.anycubic.nfc/native
 *
 * Supports:
 * - MiFare Ultralight (Anycubic/NTAG tags)
 * - MiFare Classic 1K (Bambu Lab tags)
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
        private const val CMD_WRITE_CLASSIC: Byte = 0xA0.toByte()
        private const val CMD_AUTH_KEY_A: Byte = 0x60

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
    private var currentMode: NfcMode = NfcMode.IDLE
    private var pagesToWrite: List<Map<String, Any>>? = null
    private var bambuBlocksToWrite: Map<String, List<Int>>? = null

    private val coroutineScope = CoroutineScope(Dispatchers.IO + SupervisorJob())
    private val mainHandler = Handler(Looper.getMainLooper())
    private var timeoutRunnable: Runnable? = null
    private val SCAN_TIMEOUT_MS = 30_000L // 30 seconds timeout

    private var openPrintTagDataToWrite: ByteArray? = null

    enum class NfcMode {
        IDLE,
        READ_SESSION,
        WRITE_SESSION,
        READ_BAMBU_LAB,
        WRITE_BAMBU_CLONE,
        READ_OPEN_PRINT_TAG,
        WRITE_OPEN_PRINT_TAG,
        AUTO_DETECT
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
                @Suppress("UNCHECKED_CAST")
                val pages = args?.get("pages") as? List<Map<String, Any>>
                if (pages == null) {
                    result.error("INVALID_ARGS", "Missing pages argument", null)
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
            else -> result.notImplemented()
        }
    }

    private fun startReadSession(result: MethodChannel.Result) {
        Log.d(TAG, "Starting read session")

        if (nfcAdapter == null) {
            result.error("NFC_NOT_AVAILABLE", "NFC is not available", null)
            return
        }

        if (!nfcAdapter!!.isEnabled) {
            result.error("NFC_DISABLED", "NFC is disabled", null)
            return
        }

        pendingResult = result
        currentMode = NfcMode.READ_SESSION
        enableReaderMode()
    }

    private fun startWriteSession(pages: List<Map<String, Any>>, result: MethodChannel.Result) {
        Log.d(TAG, "Starting write session with ${pages.size} pages")

        if (nfcAdapter == null) {
            result.error("NFC_NOT_AVAILABLE", "NFC is not available", null)
            return
        }

        if (!nfcAdapter!!.isEnabled) {
            result.error("NFC_DISABLED", "NFC is disabled", null)
            return
        }

        pendingResult = result
        pagesToWrite = pages
        currentMode = NfcMode.WRITE_SESSION
        enableReaderMode()
    }

    private fun startBambuLabReadSession(result: MethodChannel.Result) {
        Log.d(TAG, "Starting Bambu Lab read session")

        if (nfcAdapter == null) {
            result.error("NFC_NOT_AVAILABLE", "NFC is not available", null)
            return
        }

        if (!nfcAdapter!!.isEnabled) {
            result.error("NFC_DISABLED", "NFC is disabled", null)
            return
        }

        pendingResult = result
        currentMode = NfcMode.READ_BAMBU_LAB
        enableReaderMode()
    }

    private fun startOpenPrintTagReadSession(result: MethodChannel.Result) {
        Log.d(TAG, "Starting OpenPrintTag read session")

        if (nfcAdapter == null) {
            result.error("NFC_NOT_AVAILABLE", "NFC is not available", null)
            return
        }

        if (!nfcAdapter!!.isEnabled) {
            result.error("NFC_DISABLED", "NFC is disabled", null)
            return
        }

        pendingResult = result
        currentMode = NfcMode.READ_OPEN_PRINT_TAG
        enableReaderMode()
    }

    private fun startAutoDetectReadSession(result: MethodChannel.Result) {
        Log.d(TAG, "Starting auto-detect read session")

        if (nfcAdapter == null) {
            result.error("NFC_NOT_AVAILABLE", "NFC is not available", null)
            return
        }

        if (!nfcAdapter!!.isEnabled) {
            result.error("NFC_DISABLED", "NFC is disabled", null)
            return
        }

        pendingResult = result
        currentMode = NfcMode.AUTO_DETECT
        enableReaderMode()
    }

    private fun startOpenPrintTagWriteSession(data: ByteArray, result: MethodChannel.Result) {
        Log.d(TAG, "Starting OpenPrintTag write session: ${data.size} bytes")

        if (nfcAdapter == null) {
            result.error("NFC_NOT_AVAILABLE", "NFC is not available", null)
            return
        }

        if (!nfcAdapter!!.isEnabled) {
            result.error("NFC_DISABLED", "NFC is disabled", null)
            return
        }

        pendingResult = result
        openPrintTagDataToWrite = data
        currentMode = NfcMode.WRITE_OPEN_PRINT_TAG
        enableReaderMode()
    }

    private fun startBambuLabWriteSession(blocks: Map<String, List<Int>>, result: MethodChannel.Result) {
        Log.d(TAG, "Starting Bambu Lab write session")

        if (nfcAdapter == null) {
            result.error("NFC_NOT_AVAILABLE", "NFC is not available", null)
            return
        }

        if (!nfcAdapter!!.isEnabled) {
            result.error("NFC_DISABLED", "NFC is disabled", null)
            return
        }

        pendingResult = result
        bambuBlocksToWrite = blocks
        currentMode = NfcMode.WRITE_BAMBU_CLONE
        enableReaderMode()
    }

    private fun stopSession(result: MethodChannel.Result) {
        Log.d(TAG, "Stopping NFC session")

        cancelTimeout()

        // Notify pending result if any
        pendingResult?.error("USER_CANCELLED", "Session arrêtée", null)
        pendingResult = null

        // Reset state
        disableReaderMode()
        currentMode = NfcMode.IDLE
        pagesToWrite = null
        bambuBlocksToWrite = null
        openPrintTagDataToWrite = null

        result.success(true)
    }

    private var useForegroundDispatch = false

    private fun enableReaderMode() {
        // Use foreground dispatch as primary method (more compatible, especially Samsung/Android 16+)
        try {
            enableForegroundDispatchFallback()
            Log.d(TAG, "Using foreground dispatch as primary NFC method")
        } catch (e: Exception) {
            Log.e(TAG, "Foreground dispatch failed, trying enableReaderMode", e)
            try {
                val flags = NfcAdapter.FLAG_READER_NFC_A or
                           NfcAdapter.FLAG_READER_NFC_B or
                           NfcAdapter.FLAG_READER_NFC_V

                val extras = android.os.Bundle()
                extras.putInt(NfcAdapter.EXTRA_READER_PRESENCE_CHECK_DELAY, 250)

                nfcAdapter?.enableReaderMode(activity, this, flags, extras)
                useForegroundDispatch = false
                startTimeout()
                Log.d(TAG, "Reader mode enabled as fallback (flags=$flags)")
            } catch (e2: Exception) {
                Log.e(TAG, "Both NFC methods failed", e2)
                sendError("NFC_ERROR", "Cannot start NFC: ${e2.message}")
            }
        }
    }

    private fun enableForegroundDispatchFallback() {
        try {
            val intent = Intent(activity, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
            val pendingIntent = PendingIntent.getActivity(
                activity, 0, intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            )
            // Pass null for filters + techList to match ALL NFC tags (most compatible)
            nfcAdapter?.enableForegroundDispatch(activity, pendingIntent, null, null)
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

    private fun startTimeout() {
        cancelTimeout()
        timeoutRunnable = Runnable {
            Log.w(TAG, "⏱️ NFC scan timeout after ${SCAN_TIMEOUT_MS}ms")
            if (pendingResult != null) {
                pendingResult?.error("TAG_NOT_DETECTED", "Aucun tag NFC détecté après ${SCAN_TIMEOUT_MS / 1000}s. Le tag est peut-être mort ou incompatible.", null)
                pendingResult = null
            }
            disableReaderMode()
            currentMode = NfcMode.IDLE
            pagesToWrite = null
            bambuBlocksToWrite = null
            openPrintTagDataToWrite = null
        }
        mainHandler.postDelayed(timeoutRunnable!!, SCAN_TIMEOUT_MS)
    }

    private fun cancelTimeout() {
        timeoutRunnable?.let { mainHandler.removeCallbacks(it) }
        timeoutRunnable = null
    }

    override fun onTagDiscovered(tag: Tag?) {
        Log.d(TAG, "Tag discovered: ${tag?.techList?.joinToString()}")
        cancelTimeout() // Tag found, cancel the timeout

        if (tag == null) {
            sendError("NO_TAG", "No tag detected")
            return
        }

        // Detect NFC-V (ISO 15693) tags - e.g. Prusa OpenPrintTag
        val nfcV = NfcV.get(tag)
        if (nfcV != null && currentMode != NfcMode.READ_OPEN_PRINT_TAG && currentMode != NfcMode.AUTO_DETECT && currentMode != NfcMode.WRITE_OPEN_PRINT_TAG) {
            val techList = tag.techList.joinToString(", ")
            val tagId = tag.id?.joinToString(":") { String.format("%02x", it) } ?: "unknown"
            Log.w(TAG, "📡 NFC-V (ISO 15693) tag detected - ID: $tagId, techs: $techList")
            sendError("INCOMPATIBLE_TAG",
                "Tag NFC détecté mais de type ISO 15693 (NFC-V). Ce type est utilisé par Prusa (OpenPrintTag) et n'est pas encore supporté dans ce mode. Sélectionnez le mode Prusa.")
            return
        }

        coroutineScope.launch {
            try {
                when (currentMode) {
                    NfcMode.READ_SESSION -> handleReadSession(tag)
                    NfcMode.WRITE_SESSION -> handleWriteSession(tag)
                    NfcMode.READ_BAMBU_LAB -> handleBambuLabRead(tag)
                    NfcMode.WRITE_BAMBU_CLONE -> handleBambuLabWrite(tag)
                    NfcMode.READ_OPEN_PRINT_TAG -> handleOpenPrintTagRead(tag)
                    NfcMode.WRITE_OPEN_PRINT_TAG -> handleOpenPrintTagWrite(tag)
                    NfcMode.AUTO_DETECT -> handleAutoDetectRead(tag)
                    NfcMode.IDLE -> { /* Do nothing */ }
                }
            } catch (e: Exception) {
                Log.e(TAG, "Error processing tag", e)
                sendError("TAG_ERROR", e.message ?: "Unknown error")
            } finally {
                withContext(Dispatchers.Main) {
                    disableReaderMode()
                    currentMode = NfcMode.IDLE
                }
            }
        }
    }

    // ==================== READ SESSION (MiFare Ultralight) ====================

    private suspend fun handleReadSession(tag: Tag) {
        Log.d(TAG, "Handling read session")

        // Try MiFare Ultralight first (Anycubic/NTAG)
        val mifare = MifareUltralight.get(tag)
        if (mifare != null) {
            readMifareUltralight(mifare)
            return
        }

        // Fallback to NfcA for generic reading
        val nfcA = NfcA.get(tag)
        if (nfcA != null) {
            readWithNfcA(nfcA)
            return
        }

        sendError("INVALID_TAG", "Tag not supported")
    }

    private suspend fun readMifareUltralight(mifare: MifareUltralight) {
        try {
            mifare.connect()
            Log.d(TAG, "Connected to MiFare Ultralight")

            val allData = ByteArray(160) // 40 pages * 4 bytes
            var offset = 0

            // Read 40 pages (pages 0-39)
            for (startPage in 0 until 40 step 4) {
                try {
                    val data = mifare.readPages(startPage)
                    if (data != null && data.isNotEmpty()) {
                        val bytesToCopy = minOf(data.size, 160 - offset)
                        System.arraycopy(data, 0, allData, offset, bytesToCopy)
                        offset += bytesToCopy
                        Log.d(TAG, "Read pages $startPage-${startPage + 3}: ${data.toHexString()}")
                    }
                } catch (e: IOException) {
                    Log.w(TAG, "Error reading page $startPage: ${e.message}")
                    break
                }
            }

            mifare.close()

            // Convert to result
            val dataString = allData.decodeToStringOrEmpty()
            val rawBytes = allData.take(offset).map { it.toInt() and 0xFF }

            val resultData = mapOf(
                "data" to dataString,
                "rawBytes" to rawBytes
            )

            sendSuccess(resultData)

        } catch (e: Exception) {
            Log.e(TAG, "Error reading MiFare Ultralight", e)
            try { mifare.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
    }

    private suspend fun readWithNfcA(nfcA: NfcA) {
        try {
            nfcA.connect()
            Log.d(TAG, "Connected via NfcA")

            val allData = mutableListOf<Byte>()

            // Read pages using raw commands
            for (page in 0 until 40) {
                try {
                    val command = byteArrayOf(CMD_READ, page.toByte())
                    val response = nfcA.transceive(command)
                    if (response != null && response.isNotEmpty()) {
                        // READ command returns 16 bytes (4 pages)
                        allData.addAll(response.take(4).toList())
                        Log.d(TAG, "Read page $page: ${response.take(4).toByteArray().toHexString()}")
                    }
                } catch (e: IOException) {
                    Log.w(TAG, "Error reading page $page: ${e.message}")
                    break
                }
            }

            nfcA.close()

            val dataArray = allData.toByteArray()
            val dataString = dataArray.decodeToStringOrEmpty()
            val rawBytes = allData.map { it.toInt() and 0xFF }

            val resultData = mapOf(
                "data" to dataString,
                "rawBytes" to rawBytes
            )

            sendSuccess(resultData)

        } catch (e: Exception) {
            Log.e(TAG, "Error reading with NfcA", e)
            try { nfcA.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
    }

    // ==================== WRITE SESSION (MiFare Ultralight) ====================

    private suspend fun handleWriteSession(tag: Tag) {
        Log.d(TAG, "Handling write session")

        val pages = pagesToWrite
        if (pages == null || pages.isEmpty()) {
            sendError("INVALID_ARGS", "No pages to write")
            return
        }

        val mifare = MifareUltralight.get(tag)
        if (mifare != null) {
            writeMifareUltralight(mifare, pages)
            return
        }

        // Fallback to NfcA
        val nfcA = NfcA.get(tag)
        if (nfcA != null) {
            writeWithNfcA(nfcA, pages)
            return
        }

        sendError("INVALID_TAG", "Tag not supported for writing")
    }

    private suspend fun writeMifareUltralight(mifare: MifareUltralight, pages: List<Map<String, Any>>) {
        try {
            mifare.connect()
            Log.d(TAG, "Connected to MiFare Ultralight for writing")

            for (pageInfo in pages) {
                val pageNumber = (pageInfo["page"] as? Number)?.toInt() ?: continue
                @Suppress("UNCHECKED_CAST")
                val dataList = pageInfo["data"] as? List<Number> ?: continue

                if (dataList.size != 4) {
                    Log.w(TAG, "Invalid data size for page $pageNumber: ${dataList.size}")
                    continue
                }

                val data = dataList.map { it.toByte() }.toByteArray()

                try {
                    mifare.writePage(pageNumber, data)
                    Log.d(TAG, "Written page $pageNumber: ${data.toHexString()}")
                } catch (e: IOException) {
                    Log.e(TAG, "Error writing page $pageNumber", e)
                    throw e
                }
            }

            mifare.close()
            pagesToWrite = null
            sendSuccess(true)

        } catch (e: Exception) {
            Log.e(TAG, "Error writing MiFare Ultralight", e)
            try { mifare.close() } catch (_: Exception) {}
            pagesToWrite = null
            sendError("WRITE_ERROR", e.message ?: "Write failed")
        }
    }

    private suspend fun writeWithNfcA(nfcA: NfcA, pages: List<Map<String, Any>>) {
        try {
            nfcA.connect()
            Log.d(TAG, "Connected via NfcA for writing")

            for (pageInfo in pages) {
                val pageNumber = (pageInfo["page"] as? Number)?.toInt() ?: continue
                @Suppress("UNCHECKED_CAST")
                val dataList = pageInfo["data"] as? List<Number> ?: continue

                if (dataList.size != 4) {
                    Log.w(TAG, "Invalid data size for page $pageNumber: ${dataList.size}")
                    continue
                }

                val data = dataList.map { it.toByte() }.toByteArray()

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
            pagesToWrite = null
            sendSuccess(true)

        } catch (e: Exception) {
            Log.e(TAG, "Error writing with NfcA", e)
            try { nfcA.close() } catch (_: Exception) {}
            pagesToWrite = null
            sendError("WRITE_ERROR", e.message ?: "Write failed")
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
            val ultralight = MifareUltralight.get(tag)
            if (ultralight != null) {
                readMifareUltralightWithTagType(ultralight, "ultralight")
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
                sak.toInt() == 0x00 -> readWithNfcATagType(nfcA, "ultralight")
                sak.toInt() == 0x08 || sak.toInt() == 0x18 -> readMifareClassicWithNfcA(nfcA)
                else -> readWithNfcATagType(nfcA, "unknown")
            }
            return
        }

        sendError("INVALID_TAG", "Tag not supported")
    }

    private suspend fun readMifareUltralightWithTagType(mifare: MifareUltralight, tagType: String) {
        try {
            mifare.connect()
            Log.d(TAG, "Connected to MiFare Ultralight (tagType: $tagType)")

            val allData = ByteArray(160)
            var offset = 0

            for (startPage in 0 until 40 step 4) {
                try {
                    val data = mifare.readPages(startPage)
                    if (data != null && data.isNotEmpty()) {
                        val bytesToCopy = minOf(data.size, 160 - offset)
                        System.arraycopy(data, 0, allData, offset, bytesToCopy)
                        offset += bytesToCopy
                    }
                } catch (e: IOException) {
                    break
                }
            }

            mifare.close()

            val dataString = allData.decodeToStringOrEmpty()
            val rawBytes = allData.take(offset).map { it.toInt() and 0xFF }

            val resultData = mapOf(
                "data" to dataString,
                "rawBytes" to rawBytes,
                "tagType" to tagType
            )

            sendSuccess(resultData)

        } catch (e: Exception) {
            try { mifare.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
    }

    private suspend fun readWithNfcATagType(nfcA: NfcA, tagType: String) {
        try {
            nfcA.connect()
            val allData = mutableListOf<Byte>()

            for (page in 0 until 40) {
                try {
                    val command = byteArrayOf(CMD_READ, page.toByte())
                    val response = nfcA.transceive(command)
                    if (response != null && response.isNotEmpty()) {
                        allData.addAll(response.take(4).toList())
                    }
                } catch (e: IOException) {
                    break
                }
            }

            nfcA.close()

            val dataArray = allData.toByteArray()
            val dataString = dataArray.decodeToStringOrEmpty()
            val rawBytes = allData.map { it.toInt() and 0xFF }

            val resultData = mapOf(
                "data" to dataString,
                "rawBytes" to rawBytes,
                "tagType" to tagType
            )

            sendSuccess(resultData)

        } catch (e: Exception) {
            try { nfcA.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
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

    private suspend fun readMifareClassic(classic: MifareClassic) {
        try {
            classic.connect()
            val uid = classic.tag.id
            val derivedKeys = deriveBambuKeys(uid)
            Log.d(TAG, "Connected to MiFare Classic, UID: ${uid.toHexString()}")
            Log.d(TAG, "Type: ${classic.type}, Size: ${classic.size}, Sectors: ${classic.sectorCount}")

            val blockData = mutableMapOf<Int, ByteArray>()

            // Read all sectors (16 sectors for 1K)
            for (sector in 0 until classic.sectorCount) {
                // Try HKDF-derived key first, then fallback to default
                val authSuccess = try {
                    classic.authenticateSectorWithKeyA(sector, derivedKeys[sector])
                } catch (e: Exception) {
                    Log.d(TAG, "HKDF key failed for sector $sector, trying default key")
                    try {
                        classic.authenticateSectorWithKeyA(sector, DEFAULT_KEY)
                    } catch (e2: Exception) {
                        Log.w(TAG, "Default Key A failed for sector $sector: ${e2.message}")
                        try {
                            classic.authenticateSectorWithKeyB(sector, DEFAULT_KEY)
                        } catch (e3: Exception) {
                            Log.w(TAG, "All keys failed for sector $sector")
                            false
                        }
                    }
                }

                if (!authSuccess) {
                    Log.w(TAG, "Could not authenticate sector $sector")
                    continue
                }

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

            // Parse Bambu Lab data
            val parsedData = parseBambuLabData(blockData)
            sendSuccess(parsedData)

        } catch (e: Exception) {
            Log.e(TAG, "Error reading MiFare Classic", e)
            try { classic.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
    }

    private suspend fun readMifareClassicWithNfcA(nfcA: NfcA) {
        try {
            nfcA.connect()
            val uid = nfcA.tag.id
            val derivedKeys = deriveBambuKeys(uid)
            Log.d(TAG, "Reading MiFare Classic via NfcA, UID: ${uid.toHexString()}")

            val blockData = mutableMapOf<Int, ByteArray>()

            // Read 16 sectors
            for (sector in 0 until 16) {
                // Try HKDF-derived key first, then fallback to default
                val hkdfAuth = byteArrayOf(CMD_AUTH_KEY_A, sector.toByte()) + derivedKeys[sector]
                var authenticated = false
                try {
                    nfcA.transceive(hkdfAuth)
                    authenticated = true
                } catch (e: IOException) {
                    Log.d(TAG, "HKDF key failed for sector $sector via NfcA, trying default")
                    val defaultAuth = byteArrayOf(CMD_AUTH_KEY_A, sector.toByte()) + DEFAULT_KEY
                    try {
                        nfcA.transceive(defaultAuth)
                        authenticated = true
                    } catch (e2: IOException) {
                        Log.w(TAG, "All keys failed for sector $sector via NfcA")
                    }
                }
                if (!authenticated) continue

                // Read 3 data blocks per sector (skip sector trailer)
                for (blockInSector in 0 until 3) {
                    val blockIndex = sector * 4 + blockInSector
                    try {
                        val readCommand = byteArrayOf(CMD_READ, blockIndex.toByte())
                        val data = nfcA.transceive(readCommand)
                        if (data != null && data.size >= 16) {
                            blockData[blockIndex] = data.take(16).toByteArray()
                            Log.d(TAG, "Read block $blockIndex: ${data.take(16).toByteArray().toHexString()}")
                        }
                    } catch (e: IOException) {
                        Log.w(TAG, "Error reading block $blockIndex: ${e.message}")
                    }
                }
            }

            nfcA.close()

            val parsedData = parseBambuLabData(blockData)
            sendSuccess(parsedData)

        } catch (e: Exception) {
            try { nfcA.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
    }

    private fun parseBambuLabData(blockData: Map<Int, ByteArray>): Map<String, Any> {
        val result = mutableMapOf<String, Any>()

        // Extract raw blocks for cloning
        val rawBlocks = mutableMapOf<String, List<Int>>()
        for ((blockNum, data) in blockData) {
            rawBlocks["block_$blockNum"] = data.map { it.toInt() and 0xFF }
        }
        result["rawBlocks"] = rawBlocks

        // Parse block 5: Filament type and temperatures
        blockData[5]?.let { block5 ->
            if (block5.size >= 16) {
                result["materialIndex"] = block5[0].toInt() and 0xFF

                // Little-endian temperatures
                result["extruderTempMin"] = (block5[4].toInt() and 0xFF) or ((block5[5].toInt() and 0xFF) shl 8)
                result["extruderTempMax"] = (block5[6].toInt() and 0xFF) or ((block5[7].toInt() and 0xFF) shl 8)
                result["bedTempMin"] = (block5[8].toInt() and 0xFF) or ((block5[9].toInt() and 0xFF) shl 8)
                result["bedTempMax"] = (block5[10].toInt() and 0xFF) or ((block5[11].toInt() and 0xFF) shl 8)
            }
        }

        // Parse block 6: Color
        blockData[6]?.let { block6 ->
            if (block6.size >= 4) {
                val r = block6[0].toInt() and 0xFF
                val g = block6[1].toInt() and 0xFF
                val b = block6[2].toInt() and 0xFF
                val a = block6[3].toInt() and 0xFF
                result["colorRgb"] = (a shl 24) or (r shl 16) or (g shl 8) or b
            }
        }

        // Parse block 12: Production timestamp
        blockData[12]?.let { block12 ->
            if (block12.size >= 4) {
                val timestamp = (block12[0].toInt() and 0xFF) or
                        ((block12[1].toInt() and 0xFF) shl 8) or
                        ((block12[2].toInt() and 0xFF) shl 16) or
                        ((block12[3].toInt() and 0xFF) shl 24)
                result["productionTimestamp"] = timestamp
            }
        }

        // Parse block 14: Weight, length, diameter
        blockData[14]?.let { block14 ->
            if (block14.size >= 6) {
                result["weightGrams"] = (block14[0].toInt() and 0xFF) or ((block14[1].toInt() and 0xFF) shl 8)
                result["spoolLength"] = (block14[2].toInt() and 0xFF) or ((block14[3].toInt() and 0xFF) shl 8)
                val diameterRaw = (block14[4].toInt() and 0xFF) or ((block14[5].toInt() and 0xFF) shl 8)
                result["diameter"] = diameterRaw / 100.0
            }
        }

        return result
    }

    // ==================== OPEN PRINT TAG READ (ISO 15693 / NFC-V) ====================

    private suspend fun handleOpenPrintTagRead(tag: Tag) {
        Log.d(TAG, "Handling OpenPrintTag read")

        val nfcV = NfcV.get(tag)
        if (nfcV == null) {
            sendError("INVALID_TAG", "Tag is not ISO 15693 (NFC-V)")
            return
        }

        try {
            nfcV.connect()
            Log.d(TAG, "Connected to NFC-V tag")

            val allData = mutableListOf<Byte>()
            val maxBlocks = 64 // Read up to 256 bytes (4 bytes/block)

            for (blockNum in 0 until maxBlocks) {
                try {
                    // ISO 15693 Read Single Block command
                    // Flags: 0x02 (high data rate)
                    // Command: 0x20 (READ_SINGLE_BLOCK)
                    // Block number
                    val cmd = byteArrayOf(0x02, 0x20, blockNum.toByte())
                    val response = nfcV.transceive(cmd)

                    if (response != null && response.size > 1) {
                        // First byte is status flags, rest is data
                        val blockData = response.drop(1)
                        allData.addAll(blockData.toList())

                        Log.d(TAG, "Block $blockNum: ${blockData.toByteArray().joinToString(" ") { String.format("%02x", it) }}")

                        // Check for NDEF terminator (0xFE) after CC bytes
                        if (blockNum > 4 && blockData.any { it == 0xFE.toByte() }) {
                            Log.d(TAG, "NDEF terminator found at block $blockNum")
                            break
                        }
                    }
                } catch (e: IOException) {
                    // End of readable memory
                    Log.d(TAG, "End of readable memory at block $blockNum")
                    break
                }
            }

            nfcV.close()

            Log.d(TAG, "OpenPrintTag: ${allData.size} bytes read")

            val rawBytes = allData.map { it.toInt() and 0xFF }
            val resultData = mapOf("rawBytes" to rawBytes)

            sendSuccess(resultData)

        } catch (e: Exception) {
            Log.e(TAG, "Error reading NFC-V tag", e)
            try { nfcV.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
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
                nfcV.transceive(cmd)

                Log.d(TAG, "Written block $blockNum: ${blockData.joinToString(" ") { String.format("%02X", it) }}")
            }

            nfcV.close()
            openPrintTagDataToWrite = null
            Log.d(TAG, "OpenPrintTag write complete: $totalBlocks blocks written")
            sendSuccess(true)

        } catch (e: Exception) {
            Log.e(TAG, "Error writing NFC-V tag", e)
            try { nfcV.close() } catch (_: Exception) {}
            openPrintTagDataToWrite = null
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

        // 2. Check for MiFare Classic - Bambu Lab
        val techList = tag.techList
        if (techList.contains(MifareClassic::class.java.name)) {
            val classic = MifareClassic.get(tag)
            if (classic != null) {
                Log.d(TAG, "Auto-detect: MiFare Classic (Bambu Lab) tag detected")
                readMifareClassicWithTagType(classic, "bambu")
                return
            }
        }

        // 3. Check for MiFare Ultralight - Anycubic
        if (techList.contains(MifareUltralight::class.java.name)) {
            val ultralight = MifareUltralight.get(tag)
            if (ultralight != null) {
                Log.d(TAG, "Auto-detect: MiFare Ultralight (Anycubic) tag detected")
                readMifareUltralightWithTagType(ultralight, "anycubic")
                return
            }
        }

        // 4. Fallback to NfcA with SAK-based detection
        val nfcA = NfcA.get(tag)
        if (nfcA != null) {
            val sak = nfcA.sak
            Log.d(TAG, "Auto-detect: NfcA tag, SAK=$sak")
            when {
                sak.toInt() == 0x00 -> readWithNfcATagType(nfcA, "anycubic")
                sak.toInt() == 0x08 || sak.toInt() == 0x18 -> readMifareClassicWithNfcA(nfcA)
                else -> readWithNfcATagType(nfcA, "anycubic")
            }
            return
        }

        sendError("INVALID_TAG", "Tag not supported")
    }

    private suspend fun handleOpenPrintTagReadWithTagType(tag: Tag) {
        val nfcV = NfcV.get(tag) ?: run {
            sendError("INVALID_TAG", "Tag is not ISO 15693 (NFC-V)")
            return
        }

        try {
            nfcV.connect()
            Log.d(TAG, "Connected to NFC-V tag (auto-detect)")

            val allData = mutableListOf<Byte>()
            val maxBlocks = 64

            for (blockNum in 0 until maxBlocks) {
                try {
                    val cmd = byteArrayOf(0x02, 0x20, blockNum.toByte())
                    val response = nfcV.transceive(cmd)

                    if (response != null && response.size > 1) {
                        val blockData = response.drop(1)
                        allData.addAll(blockData.toList())

                        if (blockNum > 4 && blockData.any { it == 0xFE.toByte() }) {
                            break
                        }
                    }
                } catch (e: IOException) {
                    break
                }
            }

            nfcV.close()

            val rawBytes = allData.map { it.toInt() and 0xFF }
            val resultData = mapOf(
                "rawBytes" to rawBytes,
                "tagType" to "prusa"
            )

            sendSuccess(resultData)

        } catch (e: Exception) {
            Log.e(TAG, "Error reading NFC-V tag (auto-detect)", e)
            try { nfcV.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
    }

    private suspend fun readMifareClassicWithTagType(classic: MifareClassic, tagType: String) {
        try {
            classic.connect()
            Log.d(TAG, "Connected to MiFare Classic (auto-detect)")

            val blockData = mutableMapOf<Int, ByteArray>()

            for (sector in 0 until classic.sectorCount) {
                val authSuccess = try {
                    classic.authenticateSectorWithKeyA(sector, DEFAULT_KEY)
                } catch (e: Exception) {
                    try {
                        classic.authenticateSectorWithKeyB(sector, DEFAULT_KEY)
                    } catch (e2: Exception) {
                        false
                    }
                }

                if (!authSuccess) continue

                val firstBlock = classic.sectorToBlock(sector)
                val blockCount = classic.getBlockCountInSector(sector)

                for (i in 0 until blockCount - 1) {
                    val blockIndex = firstBlock + i
                    try {
                        val data = classic.readBlock(blockIndex)
                        if (data != null) {
                            blockData[blockIndex] = data
                        }
                    } catch (e: IOException) {
                        Log.w(TAG, "Error reading block $blockIndex: ${e.message}")
                    }
                }
            }

            classic.close()

            val parsedData = parseBambuLabData(blockData).toMutableMap()
            parsedData["tagType"] = tagType
            sendSuccess(parsedData)

        } catch (e: Exception) {
            Log.e(TAG, "Error reading MiFare Classic (auto-detect)", e)
            try { classic.close() } catch (_: Exception) {}
            sendError("READ_ERROR", e.message ?: "Read failed")
        }
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

        // Fallback to NfcA
        val nfcA = NfcA.get(tag)
        if (nfcA != null) {
            writeMifareClassicWithNfcA(nfcA, blocks)
            return
        }

        sendError("INVALID_TAG", "Tag not supported for Bambu Lab cloning")
    }

    private suspend fun writeMifareClassic(classic: MifareClassic, blocks: Map<String, List<Int>>) {
        try {
            classic.connect()
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
            bambuBlocksToWrite = null
            sendSuccess(true)

        } catch (e: Exception) {
            Log.e(TAG, "Error writing MiFare Classic", e)
            try { classic.close() } catch (_: Exception) {}
            bambuBlocksToWrite = null
            sendError("WRITE_ERROR", e.message ?: "Write failed")
        }
    }

    private suspend fun writeMifareClassicWithNfcA(nfcA: NfcA, blocks: Map<String, List<Int>>) {
        try {
            nfcA.connect()
            Log.d(TAG, "Writing MiFare Classic via NfcA")

            val sortedBlocks = blocks.entries
                .mapNotNull { (key, value) ->
                    val blockNum = key.removePrefix("block_").toIntOrNull()
                    if (blockNum != null) blockNum to value else null
                }
                .sortedBy { it.first }

            for ((blockNumber, dataList) in sortedBlocks) {
                if (blockNumber % 4 == 3) {
                    continue
                }

                val sector = blockNumber / 4

                // Authenticate
                val authCommand = byteArrayOf(CMD_AUTH_KEY_A, sector.toByte()) + DEFAULT_KEY
                try {
                    nfcA.transceive(authCommand)
                } catch (e: IOException) {
                    throw IOException("Authentication failed for sector $sector")
                }

                // Prepare data
                val data = ByteArray(16)
                for (i in 0 until minOf(dataList.size, 16)) {
                    data[i] = dataList[i].toByte()
                }

                // Write command
                val writeCommand = byteArrayOf(CMD_WRITE_CLASSIC, blockNumber.toByte()) + data
                nfcA.transceive(writeCommand)
                Log.d(TAG, "Written block $blockNumber: ${data.toHexString()}")
            }

            nfcA.close()
            bambuBlocksToWrite = null
            sendSuccess(true)

        } catch (e: Exception) {
            try { nfcA.close() } catch (_: Exception) {}
            bambuBlocksToWrite = null
            sendError("WRITE_ERROR", e.message ?: "Write failed")
        }
    }

    // ==================== HELPERS ====================

    private fun sendSuccess(data: Any) {
        activity.runOnUiThread {
            pendingResult?.success(data)
            pendingResult = null
        }
    }

    private fun sendError(code: String, message: String) {
        activity.runOnUiThread {
            pendingResult?.error(code, message, null)
            pendingResult = null
            disableReaderMode()
            currentMode = NfcMode.IDLE
        }
    }

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
