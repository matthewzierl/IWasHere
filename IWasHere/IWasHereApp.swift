//
//  IWasHereApp.swift
//  IWasHere
//
//  Created by Matthew Zierl on 5/12/24.
//

import SwiftUI
import GoogleMaps

@main // start of app
struct IWasHereApp: App {
    
    // Creating an instance of AppDelegate using UIApplicationDelegateAdaptor
    // SwiftUI uses
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Custom AppDelegate class to handle application lifecycle events
/*
    - Initialize Google Maps API w/ API key
 */
class AppDelegate: NSObject, UIApplicationDelegate {
    
    /*
        - Ensures necessary setup code runs when application finishes launching
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Provide the Google Maps API key
        GMSServices.provideAPIKey("AIzaSyBYGT2GlbBNKFCkgszCAQNr5RsNvhS4dQo")
        
        return true
    }
}

