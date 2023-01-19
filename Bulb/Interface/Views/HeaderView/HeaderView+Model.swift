//
//  HeaderView+Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 28/11/2022.
//

import Foundation

extension HeaderView {
    struct Model: Equatable {
        let title: String
        let fontSize: CGFloat

        init(
            title: String,
            fontSize: CGFloat = 18
        ) {
            self.title = title
            self.fontSize = fontSize
        }
    }
}
