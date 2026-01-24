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
import android.os.Build
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.io.IOException

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

        private var instance: NativeNfcPlugin? = null

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

    enum class NfcMode {
        IDLE,
        READ_SESSION,
        WRITE_SESSION,
        READ_BAMBU_LAB,
        WRITE_BAMBU_CLONE
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

        // Notify pending result if any
        pendingResult?.error("USER_CANCELLED", "Session arrêtée", null)
        pendingResult = null

        // Reset state
        disableReaderMode()
        currentMode = NfcMode.IDLE
        pagesToWrite = null
        bambuBlocksToWrite = null

        result.success(true)
    }

    private fun enableReaderMode() {
        val flags = NfcAdapter.FLAG_READER_NFC_A or
                   NfcAdapter.FLAG_READER_NFC_B or
                   NfcAdapter.FLAG_READER_SKIP_NDEF_CHECK

        nfcAdapter?.enableReaderMode(activity, this, flags, null)
        Log.d(TAG, "Reader mode enabled")
    }

    private fun disableReaderMode() {
        nfcAdapter?.disableReaderMode(activity)
        Log.d(TAG, "Reader mode disabled")
    }

    override fun onTagDiscovered(tag: Tag?) {
        Log.d(TAG, "Tag discovered: ${tag?.techList?.joinToString()}")

        if (tag == null) {
            sendError("NO_TAG", "No tag detected")
            return
        }

        coroutineScope.launch {
            try {
                when (currentMode) {
                    NfcMode.READ_SESSION -> handleReadSession(tag)
                    NfcMode.WRITE_SESSION -> handleWriteSession(tag)
                    NfcMode.READ_BAMBU_LAB -> handleBambuLabRead(tag)
                    NfcMode.WRITE_BAMBU_CLONE -> handleBambuLabWrite(tag)
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

    private suspend fun readMifareClassic(classic: MifareClassic) {
        try {
            classic.connect()
            Log.d(TAG, "Connected to MiFare Classic")
            Log.d(TAG, "Type: ${classic.type}, Size: ${classic.size}, Sectors: ${classic.sectorCount}")

            val blockData = mutableMapOf<Int, ByteArray>()

            // Read all sectors (16 sectors for 1K)
            for (sector in 0 until classic.sectorCount) {
                // Authenticate with default key
                val authSuccess = try {
                    classic.authenticateSectorWithKeyA(sector, DEFAULT_KEY)
                } catch (e: Exception) {
                    Log.w(TAG, "Auth failed for sector $sector with Key A: ${e.message}")
                    // Try Key B
                    try {
                        classic.authenticateSectorWithKeyB(sector, DEFAULT_KEY)
                    } catch (e2: Exception) {
                        Log.w(TAG, "Auth failed for sector $sector with Key B: ${e2.message}")
                        false
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
            Log.d(TAG, "Reading MiFare Classic via NfcA")

            val blockData = mutableMapOf<Int, ByteArray>()

            // Read 16 sectors
            for (sector in 0 until 16) {
                // Authenticate
                val authCommand = byteArrayOf(CMD_AUTH_KEY_A, sector.toByte()) + DEFAULT_KEY
                try {
                    nfcA.transceive(authCommand)
                } catch (e: IOException) {
                    Log.w(TAG, "Auth failed for sector $sector")
                    continue
                }

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
