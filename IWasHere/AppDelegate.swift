//
//  AppDelegate.swift
//  IWasHere
//
//  Created by Matthew Zierl on 5/17/24.
//  Copyright © 2024 matthewzierl.org. All rights reserved.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Override point for customization after application launch.
    GMSServices.provideAPIKey("AIzaSyBYGT2GlbBNKFCkgszCAQNr5RsNvhS4dQo")

    return true
  }

}
