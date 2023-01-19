//
//  SimpleHeaderVIew + Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 13/06/2022.
//

import Foundation
import UIKit

extension SimpleHeaderView {

    struct Model: Equatable {
        var title: String
        let fontSize: CGFloat

        init(title: String, fontSize: CGFloat = 18) {
            self.title = title
            self.fontSize = fontSize
        }
    }
}
