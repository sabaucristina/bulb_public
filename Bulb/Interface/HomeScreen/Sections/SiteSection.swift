//
//  SiteSection.swift
//  Bulb
//
//  Created by Sabau Cristina on 05/07/2022.
//

import Foundation

final class SiteSection: HomeScreenSectionProtocol {
    var numberOfItems: Int { sortedTasks.count }
    private let site: String
    private let tasks: [Task]
    private let onAction: (HomeSectionAction) -> Void
    private lazy var sortedTasks = tasks.sorted(by: { $0.site < $1.site })

    init(
        site: String,
        tasks: [Task],
        onAction: @escaping (HomeSectionAction) -> Void
    ) {
        self.site = site
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
                tagText: sortedTasks[index].tagLabel(),
                isUpcomingTask: false,
                onAction: { [weak self] action in
                    guard let self = self else { return }

                    let task = self.sortedTasks[index]
                    switch action {
                    case .snooze:
                        self.onAction(.showSnoozeModal(task))
                    case .complete:
                        self.onAction(.completeTask(task))
                    }
                }
            )
        )
    }

    var headerModel: SimpleHeaderView.Model? {
        .init(title: site, fontSize: 18)
    }

    func onTap(index: Int) {
        onAction(.showTaskDetails(sortedTasks[index]))
    }
}
