import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    NativeNfcPlugin.register(with: engineBridge.pluginRegistry.registrar(forPlugin: "NativeNfcPlugin")!)
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
