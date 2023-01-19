//
//  DeadlineSection.swift
//  Bulb
//
//  Created by Sabau Cristina on 19/07/2022.
//

import Foundation

final class DeadlineSection: HomeScreenSectionProtocol {
    var numberOfItems: Int { sortedTasks.count }
    private let tasks: [Task]
    private let deadline: Date
    private lazy var sortedTasks = tasks.sorted(by: { $0.deadline > $1.deadline })
    private let onAction: ((HomeSectionAction) -> Void)

    init(
        deadline: Date,
        tasks: [Task],
        onAction: @escaping (HomeSectionAction) -> Void
    ) {
        self.deadline = deadline
        self.tasks = tasks
        self.onAction = onAction
    }

    func cellModel(for index: Int) -> TableViewItemModel {
        .task(
            .init(
                plantName: "Calathea",
                isCompleted: sortedTasks[index].completed,
                isSnoozed: sortedTasks[index].snoozed,
                isSkipped: sortedTasks[index].skipped,
                taskType: sortedTasks[index].taskType,
                isUpcomingTask: true
            )
        )
    }

    private(set) lazy var headerModel: SimpleHeaderView.Model? = {
        .init(
            title: DateFormatter.mediumDateformatter.string(from: deadline),
            fontSize: 18
        )
    }()

    func onTap(index: Int) {
        onAction(.showTaskDetails(sortedTasks[index]))
    }
}

extension DateFormatter {
    static let mediumDateformatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return formatter
    }()
}
