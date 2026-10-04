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

    override fun onResume() {
        super.onResume()
        // Samsung : le foreground dispatch est perdu à chaque onPause → on le
        // réarme si une session NFC est active (mode différent de IDLE).
        NativeNfcPlugin.getInstance()?.onActivityResumed()
    }

    override fun onPause() {
        // Désactivation propre du foreground dispatch avant la mise en pause.
        NativeNfcPlugin.getInstance()?.onActivityPaused()
        super.onPause()
    }
}
