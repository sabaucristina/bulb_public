//
//  Taskw.swift
//  Bulb
//
//  Created by Sabau Cristina on 10/06/2022.
//

import Foundation

struct Task: Equatable {
    let id: String
    let taskType: String
    let site: String
    let completed: Bool
    let deadline: Date
    let description: String
    let interval: Int
    let snoozed: Bool
    let skipped: Bool
    let notes: String?
    let plant: Plant

    func tagLabel() -> String? {
        if !self.completed && (deadline < Date.now) {
            let days = Calendar.current.numberOfDaysBetween(from: deadline, to: Date.now)
            guard days > 0 else { return nil }

            return "\(days)d late"
        }

        return nil
    }
}

extension Task {
    var wasModified: Bool {
        completed || skipped || snoozed
    }
    var wasNotModified: Bool {
        !wasModified
    }
}
