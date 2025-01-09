//
//  iosApp.swift
//  ios
//
//  Created by Teodor Calin on 12/11/24.
//
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    //Auth.auth().useEmulator(withHost:"localhost", port:9099)
    return true
  }
    
    
}




@main
struct iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
