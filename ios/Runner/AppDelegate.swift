import Flutter
import UIKit
import NaverThirdPartyLogin
import app_links

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("URL Received: \(url.absoluteString)")
        
        if url.absoluteString.hasPrefix("kakao"){
            super.application(app, open:url, options: options)
            return true
        } else if url.absoluteString.contains("thirdPartyLoginResult") {
            NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
            return true
        } else if url.absoluteString.contains("seeya-app"){
            AppLinks.shared.handleLink(url: url)
            return true
        } else {
            return false
        }
    }


}
