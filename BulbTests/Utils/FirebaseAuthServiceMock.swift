//
//  FirebaseAuthServiceMock.swift
//  BulbTests
//
//  Created by Sabau Cristina on 16/01/2023.
//

import Foundation
@testable import Bulb
import UIKit

final class FirebaseAuthServiceMock: FirebaseAuthServiceProtocol {
    
    var makeAuthControllerStub: ((@escaping () -> Void) -> UIViewController)!
    func makeAuthController(
        onDidSignIn: @escaping () -> Void
    ) -> UIViewController {
        makeAuthControllerStub(onDidSignIn)
    }

    var logOutStub: (() -> Void)!
    func logOut() {
        logOutStub()
    }

    var hasCurrentUserStub: (() -> Bool)!
    func hasCurrentUser() -> Bool {
        hasCurrentUserStub()
    }
}
