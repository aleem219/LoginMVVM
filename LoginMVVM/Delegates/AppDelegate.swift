//
//  AppDelegate.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 23/05/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Root ViewController
      static func setUserVCAsRoot() {
          let userVC = AppStoryboard.mainStoryboard.instantiateViewController(identifier: StringConstants.StoryBoard.loginVC) as! LoginVC
          let nav = UINavigationController(rootViewController: userVC)
          
          if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
             let window = scene.windows.first {
              window.rootViewController = nav
              window.makeKeyAndVisible()
              UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
          }
      }


}

