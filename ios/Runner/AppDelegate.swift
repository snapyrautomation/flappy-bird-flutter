import Flutter
import Snapyr
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let configuration = SnapyrConfiguration(writeKey: "iUP1MlMXSeilS20TUUavq5vygVI8mDMT")
    // configuration.snapyrEnvironment = SnapyrEnvironment.dev
    configuration.trackApplicationLifecycleEvents = true
    configuration.recordScreenViews = true
    configuration.actionHandler = { msg in
      print("Received Snapyr in-app message! \(msg)")
    }
    Snapyr.setup(with: configuration)

    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let snapyr_channel = FlutterMethodChannel(
      name: "snapyr.com/data", binaryMessenger: controller.binaryMessenger)
    snapyr_channel.setMethodCallHandler({
      (_ call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      if call.method == "identify" {
        if let args = call.arguments as? [String: Any],
          let uid = args["userId"] as? String,
          let traits = args["traits"] as? [String: Any]
        {
          Snapyr.shared().identify(uid, traits: traits)
        } else {
          result(FlutterError.init(code: "bad args", message: nil, details: nil))
        }

      } else if call.method == "reset" {
        Snapyr.shared().reset()
      } else if call.method == "track" {
        if let args = call.arguments as? [String: Any],
          let event = args["event"] as? String,
          let properties = args["properties"] as? [String: Any]
        {
          Snapyr.shared().track(event, properties: properties)
          Snapyr.shared().flush()
        } else {
          result(FlutterError.init(code: "bad args", message: nil, details: nil))
        }
      }
    }
    )
    // Snapyr.shared().identify("brian", traits: ["email": "bone@alumni.brown.edu"])
    // Snapyr.shared().track("gamePlayed", properties: ["level": 1])
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
