//
//  CreateAccountVIewController.swift
//  Bulb
//
//  Created by Sabau Cristina on 28/04/2022.
//

import Foundation
import UIKit
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

final class CreateAccountViewController: UIViewController {

    private lazy var signupButton = makeSignupButton()
    private lazy var googleSignInButton = makeGoogleSignInButton()
    private lazy var emailTextField = makeEmailTextField()
    private lazy var passwordTextField = makePasswordTextField()
    private lazy var buttonsStack = UIStackView()

    enum Constants {
        enum Colors {
            static let textFieldBackground = UIColor.white.withAlphaComponent(0.8)
            static let textFieldForeground = UIColor.black.withAlphaComponent(0.7)
        }

        enum ContentSize {
            static let height: CGFloat = 28
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

// MARK: UI Setup
private extension CreateAccountViewController {
    func setupUI() {
        view.backgroundColor = .black
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.axis = .vertical
        buttonsStack.spacing = VerticalSpacing.pt10

        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        buttonsStack.addArrangedSubview(emailTextField)
        buttonsStack.addArrangedSubview(passwordTextField)
        buttonsStack.addArrangedSubview(signupButton)
        buttonsStack.addArrangedSubview(googleSignInButton)
        buttonsStack.setCustomSpacing(VerticalSpacing.pt20, after: passwordTextField)

        view.addSubview(buttonsStack)
    }

    func setupConstraints() {
        let constraints = [
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: UI components
private extension CreateAccountViewController {
    func makeSignupButton() -> UIButton {
        let button = SimpleButton()
        button.update(model: makeSignUpButtonModel())

        return button
    }

    func makeSignUpButtonModel() -> SimpleButton.Model {
        .init(
            title: "Sign up",
            action: {}
        )
    }

    func makeGoogleSignInButton() -> GIDSignInButton {
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.style = .standard

        googleSignInButton.addTarget(self, action: #selector(signInWithGoogle), for: .touchUpInside)

        return googleSignInButton
    }

    @objc
    func signInWithGoogle() {
        googleSignIn()
    }

    func makeEmailTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = Constants.Colors.textFieldBackground
        textField.layer.cornerRadius = Constants.ContentSize.height / 2
        textField.heightAnchor.constraint(equalToConstant: Constants.ContentSize.height).isActive = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter your email",
            attributes: [
                .font: SystemFont.ofSize18pt,
                .foregroundColor: Constants.Colors.textFieldForeground
            ]
        )

        return textField
    }

    func makePasswordTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = Constants.Colors.textFieldBackground
        textField.layer.cornerRadius = Constants.ContentSize.height / 2
        textField.heightAnchor.constraint(equalToConstant: Constants.ContentSize.height).isActive = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "Enter your password",
            attributes: [
                .font: SystemFont.ofSize18pt,
                .foregroundColor: Constants.Colors.textFieldForeground
            ]
        )

        return textField
    }
}

// MARK: Firebase - SignIn
private extension CreateAccountViewController {
    func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.signIn(
            with: config,
            presenting: self
        ) { [unowned self] user, error in
            guard error == nil else { return }

            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: authentication.accessToken
            )
            authenticateWithFirebase(with: credential)
        }
    }

    func authenticateWithFirebase(with credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { [weak self] _, error in
            guard let self = self else { return }

            if let error = error {
                self.showMessagePrompt(withMessage: error.localizedDescription)
            }

            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.seenOnboarding)
            self.navigationController?
                .setViewControllers(
                    [RootControllerFactory.makeMainScreenController()],
                    animated: false
                )
        }
    }

    func showMessagePrompt(withMessage: String) {
        let alert = UIAlertController(
            title: "Authenticate - Error",
            message: withMessage,
            preferredStyle: .actionSheet
        )

        alert.addTextField()
        let action = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
