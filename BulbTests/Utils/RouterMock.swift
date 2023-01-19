//
//  RouterMock.swift
//  BulbTests
//
//  Created by Sabau Cristina on 09/08/2022.
//

import Foundation
@testable import Bulb
import UIKit

final class RouterMock: RouterProtocol {
    var pushStub: ((UIViewController) -> Void)!
    func push(_ viewController: UIViewController) {
        pushStub(viewController)
    }
    
    var presentModalWithOptionsStub: ((UIViewController, Bool, Bool) -> Void)!
    func presentModal(_ screen: UIViewController, inMultipleDetents: Bool, embedInNavigationController: Bool) {
        presentModalWithOptionsStub(screen, inMultipleDetents, embedInNavigationController)
    }

    var presentModalStub: ((UIViewController) -> Void)!
    func presentModal(_ screen: UIViewController) {
        presentModalStub(screen)
    }

    var dismissModalWithCompletionStub: (((() -> Void)?) -> Void)!
    func dismissModal(completion: (() -> Void)?) {
        dismissModalWithCompletionStub(completion)
    }

    var dismissModalStub: (() -> Void)!
    func dismissModal() {
        dismissModalStub()
    }
}
