import Flutter
import UIKit

public class SwiftSamsungHealthReporterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "samsung_health_reporter", binaryMessenger: registrar.messenger())
    let instance = SwiftSamsungHealthReporterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
