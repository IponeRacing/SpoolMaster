package com.engagengine.nfc_anycubic

import android.content.Intent
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Enable edge-to-edge display
        WindowCompat.setDecorFitsSystemWindows(window, false)
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NativeNfcPlugin.registerWith(flutterEngine, this)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // Forward NFC intents to the plugin (for foreground dispatch fallback)
        NativeNfcPlugin.getInstance()?.handleIntent(intent)
    }
}
