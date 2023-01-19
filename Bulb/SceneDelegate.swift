//
//  SceneDelegate.swift
//  Bulb
//
//  Created by Sabau Cristina on 27/04/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let mainScreen = RootControllerFactory.makeMainScreenController()
        let onboardingScreen = RootControllerFactory.makeOnboardingController()
        let loggedIn = FirebaseAuthService().hasCurrentUser()
        let rootController = loggedIn ? mainScreen : onboardingScreen
        window = UIWindow(frame: scene.coordinateSpace.bounds)
        window?.windowScene = scene
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
}
