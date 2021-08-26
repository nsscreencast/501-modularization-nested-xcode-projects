//
//  SceneDelegate.swift
//  DinnerTime
//
//  Created by Ben Scheirman on 6/3/21.
//

import UIKit
import Models

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var rootNavigationController: UINavigationController {
        window!.rootViewController as! UINavigationController
    }
    
    private func appTabs() -> UITabBarController {
        let planVC = PlanViewController()
        let planNav = UINavigationController(rootViewController: planVC)
        
        let info = InfoViewController()
        let infoNav = UINavigationController(rootViewController: info)
        
        let tabVC = UITabBarController()
        tabVC.viewControllers = [planNav, infoNav]
        
        return tabVC
    }
    
    private func walkthroughNavigationController() -> WalkthroughNavigationController {
        let walkthrough = UIStoryboard(name: "Walkthrough", bundle: .main)
        let walkthroughVC = walkthrough.instantiateInitialViewController() as! WalkthroughNavigationController
        walkthroughVC.walkthroughDelegate = self
        return walkthroughVC
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        do {
            try CurrentState.mealStore.load()
        } catch {
            print("Error loading meals: \(error)")
        }
        
        if shouldShowWelcome {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.window?.rootViewController?.present(self.walkthroughNavigationController(), animated: true, completion: nil)
            }
        } else {
            rootNavigationController.pushViewController(appTabs(), animated: true)
        }
        
        window?.makeKeyAndVisible()
    }
    
    var shouldShowWelcome: Bool {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-ShowWelcome") {
            return true
        }
        #endif
        return CurrentState.mealStore.meals.isEmpty
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("sceneWillResignActive")
        do {
            try CurrentState.mealStore.save()
        } catch {
            print("Error saving meals: \(error)")
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("sceneDidEnterBackground")
        do {
            try CurrentState.mealStore.save()
        } catch {
            print("Error saving meals: \(error)")
        }
        
    }
}

extension SceneDelegate: WalkthroughDelegate {
    func didCompleteWalkthrough(firstDinner: String?) {
        print("Did complete walkthrough: ", firstDinner ?? "(none)")
        
        if let firstDinner = firstDinner {
            CurrentState.mealStore.add(Meal(name: firstDinner, date: Date(), type: .dinner))
        }
        
        rootNavigationController.dismiss(animated: true, completion: {
            self.rootNavigationController.pushViewController(self.appTabs(), animated: true)
        })
    }
}
