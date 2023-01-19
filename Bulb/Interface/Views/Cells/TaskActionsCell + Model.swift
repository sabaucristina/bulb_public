//
//  TaskActionsCell + Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 28/06/2022.
//

import Foundation

extension TaskActionCell {
    struct Model {
        let title: String
        var isUpcomingTask: Bool
        let onTap: () -> Void
        let onTapMoreActions: (() -> Void)?
    }
}
