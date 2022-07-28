//
//  TaskUpdateAction.swift
//  Bulb
//
//  Created by Sabau Cristina on 20/07/2022.
//

import Foundation

enum TaskUpdateAction {
    case complete
    case skip
    case snooze

    var state: String {
        switch self {
        case .complete:
            return "completed"
        case .skip:
            return "skipped"
        case .snooze:
            return "snoozed"
        }
    }
}
