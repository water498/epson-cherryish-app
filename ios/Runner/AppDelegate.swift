import Flutter
import UIKit
import app_links
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // register google map key
    GMSServices.provideAPIKey("AIzaSyBQ6PPTKT5UTIAywAhIXo6ED2_hFAWiK14")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("URL Received: \(url.absoluteString)")
        
        if url.absoluteString.hasPrefix("kakao") || url.absoluteString.hasPrefix("seeyanaverlogin"){
            super.application(app, open:url, options: options)
            return true
        } else if url.absoluteString.contains("seeya-app"){
            AppLinks.shared.handleLink(url: url)
            return true
        } else {
            return false
        }
    }


}
