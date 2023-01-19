//
//  UIView+displayError.swift
//  Bulb
//
//  Created by Sabau Cristina on 21/07/2022.
//

import Foundation
import UIKit
import Toast_Swift

extension UIView {
    func displayError(error: Error) {
        self.makeToast(
            error.localizedDescription,
            duration: 3.0,
            position: .bottom
        )
    }
}
