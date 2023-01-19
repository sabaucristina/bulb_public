//
//  OnboardingScreenViewModel.swift
//  Bulb
//
//  Created by Sabau Cristina on 16/01/2023.
//

import Foundation
import UIKit

final class OnboardingScreenViewModel {
    enum Action: Equatable {
        case presentAuthController(IgnoreEquatable<UIViewController>)
        case transitionToMainScreen
    }

    private let firebaseAuthService: FirebaseAuthServiceProtocol
    private(set) lazy var getStartedButtonModel = makeGetStartedButtonModel()

    var onAction: ((Action) -> Void)?

    init(
        firebaseAuthService: FirebaseAuthServiceProtocol
    ) {
        self.firebaseAuthService = firebaseAuthService
    }

    convenience init() {
        self.init(firebaseAuthService: FirebaseAuthService())
    }
}

// MARK: - Utils

private extension OnboardingScreenViewModel {
    func makeGetStartedButtonModel() -> SimpleButton.Model {
        .init(
            title: "Get started",
            action: { [weak self] in
                guard let self = self else { return }
                self.onAction?(.presentAuthController(IgnoreEquatable(self.makeAuthController())))
            }
        )
    }

    func makeAuthController() -> UIViewController {
        firebaseAuthService.makeAuthController { [weak self] in
            self?.onAction?(.transitionToMainScreen)
        }
    }
}
