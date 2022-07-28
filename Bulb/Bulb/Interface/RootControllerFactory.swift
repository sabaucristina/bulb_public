//
//  RootControllerFactory.swift
//  Bulb
//
//  Created by Sabau Cristina on 12/05/2022.
//

import Foundation
import UIKit

final class RootControllerFactory {
    static func makeOnboardingController() -> UIViewController {
        return OnboardingScreenViewController()
    }

    static func makeMainScreenController() -> UIViewController {
        return MainTabBarController()
    }
}
