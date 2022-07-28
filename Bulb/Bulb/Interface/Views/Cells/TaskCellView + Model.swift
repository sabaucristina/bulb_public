//
//  TaskCellView + Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 10/06/2022.
//

import Foundation

extension TaskCellView {
    enum Action {
        case snooze
        case complete
    }

    struct Model {
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
