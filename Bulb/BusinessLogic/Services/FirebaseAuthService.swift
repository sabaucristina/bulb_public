//
//  FirebaseAuthService.swift
//  Bulb
//
//  Created by Sabau Cristina on 13/01/2023.
//

import Foundation
import FirebaseAuth
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseEmailAuthUI

protocol FirebaseAuthServiceProtocol: AnyObject {
    func makeAuthController(onDidSignIn: @escaping () -> Void) -> UIViewController
    func logOut()
    func hasCurrentUser() -> Bool
}

final class FirebaseAuthService: NSObject, FirebaseAuthServiceProtocol, FUIAuthDelegate {
    private var onDidSignIn: (() -> Void)?
    let authUI = FUIAuth.defaultAuthUI()

    override init() {
        super.init()
        authUI?.delegate = self
    }

    func logOut() {
        try? Auth.auth().signOut()
    }

    func hasCurrentUser() -> Bool {
        Auth.auth().currentUser?.uid != nil
    }

    func authUI(
        _ authUI: FUIAuth,
        didSignInWith authDataResult: AuthDataResult?,
        url: URL?,
        error: Error?
    ) {
        onDidSignIn?()
    }

    func makeAuthController(onDidSignIn: @escaping () -> Void) -> UIViewController {
        self.onDidSignIn = onDidSignIn
        configureAuthUI()
        return authUI!.authViewController()
    }
}

private extension FirebaseAuthService {
    func configureAuthUI() {
        guard let authUI = authUI else { return }

        let emailAuthProvider = FUIEmailAuth(
            authAuthUI: authUI,
            signInMethod: EmailLinkAuthSignInMethod,
            forceSameDevice: false,
            allowNewEmailAccounts: true,
            actionCodeSetting: ActionCodeSettings()
        )
        let providers: [FUIAuthProvider] = [
            emailAuthProvider,
            FUIGoogleAuth(authUI: authUI)
        ]
        authUI.providers = providers
    }
}
