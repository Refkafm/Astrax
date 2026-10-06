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
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    guard let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "LocalStoragePolicy") else {
      return
    }
    let channel = FlutterMethodChannel(
      name: "catatan_uang/storage_policy",
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      guard call.method == "prepareLocalStorage" else {
        result(FlutterMethodNotImplemented)
        return
      }
      do {
        var directory = try FileManager.default.url(
          for: .applicationSupportDirectory,
          in: .userDomainMask,
          appropriateFor: nil,
          create: true
        )
        // Applies to ledger, SQLite journals and future support files.
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try directory.setResourceValues(values)
        try FileManager.default.setAttributes(
          [.protectionKey: FileProtectionType.completeUntilFirstUserAuthentication],
          ofItemAtPath: directory.path
        )
        result(nil)
      } catch {
        // Do not include financial paths, key material or raw native errors.
        result(FlutterError(code: "storage_policy_unavailable",
                            message: "Penyimpanan lokal belum siap.", details: nil))
      }
    }
  }
}
