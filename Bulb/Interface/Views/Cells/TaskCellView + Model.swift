//
//  TaskCellView + Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 10/06/2022.
//

import Foundation

extension TaskCellView {
    enum Action: Equatable {
        case snooze
        case complete
    }

    struct Model: Equatable {
        static func == (
            lhs: TaskCellView.Model,
            rhs: TaskCellView.Model
        ) -> Bool {
            lhs.plantName == rhs.plantName &&
            lhs.isCompleted == rhs.isCompleted &&
            lhs.isSnoozed == rhs.isSnoozed &&
            lhs.isSkipped == rhs.isSkipped &&
            lhs.taskType == rhs.taskType &&
            lhs.tagText == rhs.tagText &&
            lhs.isUpcomingTask == rhs.isUpcomingTask
        }

        let plantName: String
        let isCompleted: Bool
        let isSnoozed: Bool
        let isSkipped: Bool
        let taskType: String
        var tagText: String?
        var isUpcomingTask: Bool
        var onAction: ((Action) -> Void)?
    }
}
