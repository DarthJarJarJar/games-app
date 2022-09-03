//
//  GamescgApp.swift
//  Gamescg
//
//  Created by Ayaan  on 2022-08-26.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct GamescgApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var network = Network()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserData())
                .environmentObject(network)
                
            
        }
    }
}
