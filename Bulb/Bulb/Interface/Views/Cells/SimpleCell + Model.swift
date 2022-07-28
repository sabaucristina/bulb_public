//
//  SimpleCell + Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 17/06/2022.
//

import Foundation
import UIKit

extension SimpleCell {
    struct Model {
        let descriptionText: String
        let textFont: UIFont

        init(
            descriptionText: String,
            textFont: UIFont = .systemFont(ofSize: 16)
        ) {
            self.descriptionText = descriptionText
            self.textFont = textFont
        }
    }
}
