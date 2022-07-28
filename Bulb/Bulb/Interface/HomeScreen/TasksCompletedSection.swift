//
//  TasksCompletedSection.swift
//  Bulb
//
//  Created by Sabau Cristina on 08/07/2022.
//

import Foundation

final class TasksCompletedSection: HomeScreenSectionProtocol {
    var numberOfItems: Int { 1 }

    func cellModel(for index: Int) -> TableViewItemModel {
        .tasksCompleted(
            .init(
                title: "All tasks are completed",
                icon: Image.checkmarkCircle
            )
        )
    }

    var headerModel: SimpleHeaderView.Model?
}
