//
//  TextViewCell + Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 16/06/2022.
//

import Foundation
import UIKit

extension TextViewCell {
    class Model {
        var placeholder: String
        var text: String?
        let textFont: UIFont

        init(placeholder: String, text: String?, textFont: UIFont = .systemFont(ofSize: 16)
        ) {
            self.placeholder = placeholder
            self.text = text
            self.textFont = textFont
        }
    }
}
