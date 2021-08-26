//
//  AppDelegate.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/3/21.
//

import UIKit
import Styleguide

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIKitTheme.apply()
        
        #if DEBUG
        print(ProcessInfo.processInfo.arguments)
        if ProcessInfo.processInfo.arguments.contains("-ResetState") {
            try! CurrentState.mealStore.clear()
        }
        #endif
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

