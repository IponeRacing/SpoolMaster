import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDhcba2vS4v6OXeCfrKt4Lk8gxnoJ6f1pM',
    appId: '1:1091367332850:android:d05009669bc8cea734196b',
    messagingSenderId: '1091367332850',
    projectId: 'spool-master-9f9e0',
    storageBucket: 'spool-master-9f9e0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvIWoFzemHziH2nX8QwQ7hzmYL-r9gX6w',
    appId: '1:1091367332850:ios:c52dfc88975f992334196b',
    messagingSenderId: '1091367332850',
    projectId: 'spool-master-9f9e0',
    storageBucket: 'spool-master-9f9e0.firebasestorage.app',
    iosBundleId: 'com.engageengine.nfcfilament',
  );
}
