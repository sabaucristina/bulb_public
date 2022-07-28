//
//  TaskCategory.swift
//  Bulb
//
//  Created by Sabau Cristina on 25/07/2022.
//

import Foundation

enum TaskCategory: Int, CaseIterable {
    case today
    case upcoming

    var type: String {
        switch self {
        case .today:
            return "today"
        case .upcoming:
            return "upcoming"
        }
    }
}
