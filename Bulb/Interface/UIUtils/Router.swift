//
//  Router.swift
//  Bulb
//
//  Created by Sabau Cristina on 09/08/2022.
//

import Foundation
import UIKit

protocol RouterProtocol: AnyObject {
    func presentModal(
        _ screen: UIViewController,
        inMultipleDetents: Bool,
        embedInNavigationController: Bool
    )

    func push(_ viewController: UIViewController)

    func presentModal(_ screen: UIViewController)

    func dismissModal(completion: (() -> Void)?)

    func dismissModal()
}

final class Router: RouterProtocol {
    private enum Constants {
        static let taskDetailsSheetCornerRadius: CGFloat = 20
    }

    private var visibleViewController: UIViewController! {
        UIApplication.shared.visibleViewController
    }

    func presentModal(
        _ screen: UIViewController,
        inMultipleDetents: Bool,
        embedInNavigationController: Bool
    ) {
        let controller: UIViewController
        if embedInNavigationController {
            controller = UINavigationController(rootViewController: screen)
        } else {
            controller = screen
        }

        if inMultipleDetents {
            controller.modalPresentationStyle = .pageSheet
            if let sheet = controller.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.selectedDetentIdentifier = .large
                sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                sheet.preferredCornerRadius = Constants.taskDetailsSheetCornerRadius
            }
        }

        visibleViewController?.present(controller, animated: true)
    }

    func presentModal(_ screen: UIViewController) {
        presentModal(screen, inMultipleDetents: false, embedInNavigationController: false)
    }

    func dismissModal(completion: (() -> Void)?) {
        visibleViewController.dismiss(animated: true, completion: completion)
    }

    func dismissModal() {
        dismissModal(completion: nil)
    }

    func push(_ viewController: UIViewController) {
        let navigationController = visibleViewController.navigationController
            ?? visibleViewController as? UINavigationController
        guard let navigationController = navigationController else {
            assertionFailure("No navigation controller found")
            return
        }
        navigationController.pushViewController(viewController, animated: true)
    }
}
