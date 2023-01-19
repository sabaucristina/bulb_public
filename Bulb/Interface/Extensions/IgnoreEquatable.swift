//
//  eqwwe.swift
//  Bulb
//
//  Created by Sabau Cristina on 17/01/2023.
//

import Foundation

struct IgnoreEquatable<T>: Equatable {
    let value: T
    init(_ value: T) {
        self.value = value
    }

    static func == (
        lhs: IgnoreEquatable<T>,
        rhs: IgnoreEquatable<T>
    ) -> Bool {
        true
    }
}
