//
//  SceneDelegate.swift
//  LoginMVVM
//
//  Created by Abdul Aleem on 23/05/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let isLoggedIn = (MyUserDefaults.instance.get(key: MyUserDefaults.Key.id) as Int?) != nil
        
        if isLoggedIn {
            let UserVC = AppStoryboard.userStoryboard.instantiateViewController(identifier: StringConstants.StoryBoard.userVC) as! UserVC
            window?.rootViewController = UINavigationController(rootViewController: UserVC)
        } else {
            let loginVC = AppStoryboard.mainStoryboard.instantiateViewController(identifier: StringConstants.StoryBoard.loginVC) as! LoginVC
            window?.rootViewController = UINavigationController(rootViewController: loginVC)
        }
        
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

