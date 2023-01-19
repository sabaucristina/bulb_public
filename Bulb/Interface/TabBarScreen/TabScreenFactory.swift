//
//  TabScreenFactory.swift
//  Bulb
//
//  Created by Sabau Cristina on 30/05/2022.
//

import Foundation
import UIKit

final class TabScreenFactory {
    static func makeHomeScreenController() -> UIViewController {
        let controller = HomeScreenViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Home",
            image: Image.homeIcon.uiImage,
            tag: 0
        )

        return controller
    }

    static func makeSearchScreenController() -> UIViewController {
        let controller = SearchScreenViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Plants",
            image: Image.plantIcon.uiImage,
            tag: 0
        )

        return controller
    }
}
