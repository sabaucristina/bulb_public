//
//  MainTabController.swift
//  Bulb
//
//  Created by Sabau Cristina on 30/05/2022.
//

import Foundation
import UIKit

final class MainTabBarController: UITabBarController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        setupControllers()
    }
}

private extension MainTabBarController {
    func setup() {
        tabBar.backgroundColor = .white
    }

    func setupControllers() {
        viewControllers = [
            UINavigationController(
                rootViewController: TabScreenFactory.makeHomeScreenController()
            ),
            UINavigationController(
                rootViewController: TabScreenFactory.makeSearchScreenController()
            )
        ]
    }
}
