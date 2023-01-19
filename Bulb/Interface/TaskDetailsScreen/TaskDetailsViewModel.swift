//
//  TaskDetailsViewModel.swift
//  Bulb
//
//  Created by Sabau Cristina on 18/08/2022.
//

import Foundation
import UIKit

final class TaskDetailsViewModel {
    enum Action: Equatable {
        case requestUpdate(TaskUpdateRequest)
    }

    enum SectionType: Int, CaseIterable {
        case taskInstructions
        case taskDetails
    }

    enum CellModel {
        case simple(SimpleCell.Model)
        case text(TextViewCell.Model)
        case actions(TaskActionCell.Model)

        var identifier: String {
            switch self {
            case .simple:
                return SimpleCell.identifierName
            case .text:
                return TextViewCell.identifierName
            case .actions:
                return TaskActionCell.identifierName
            }
        }
    }

    struct Section {
        let type: SectionType
        let title: String
        let cellModels: [CellModel]
    }

    private var task: Task
    private let taskCategory: TaskCategory
    private let onAction: (Action) -> Void
    private var sections = [Section]()
    private var router: RouterProtocol
    private var screenFactory: TaskDetailsFactoryProtocol

    init(
        task: Task,
        taskCategory: TaskCategory,
        onAction: @escaping (Action) -> Void,
        router: RouterProtocol,
        screenFactory: TaskDetailsFactoryProtocol
    ) {
        self.task = task
        self.taskCategory = taskCategory
        self.onAction = onAction
        self.router = router
        self.screenFactory = screenFactory
    }

    convenience init(
        task: Task,
        taskCategory: TaskCategory,
        onAction: @escaping (Action) -> Void
    ) {
        self.init(
            task: task,
            taskCategory: taskCategory,
            onAction: onAction,
            router: Router(),
            screenFactory: TaskDetailsFactory()
        )
    }

    func navTitle() -> String {
        return (task.taskType.capitalized + " - " + task.site.capitalized)
    }

    func reloadData() {
        sections = [
            Section.init(
                type: .taskInstructions,
                title: "Plant Name - " + task.taskType,
                cellModels: [
                    .actions(makeTaskActionsModel())
                ]
            ),
            Section.init(
                type: .taskDetails,
                title: task.taskType + " Instructions",
                cellModels: [
                    .simple(makeSimpleCellModel())
                ]
            )
        ]
    }

    func numberOfSections() -> Int {
        sections.count
    }

    func numberOfRowsInSection(section: Int) -> Int {
        sections[section].cellModels.count
    }

    func cellModel(indexPath: IndexPath) -> CellModel {
        sections[indexPath.section].cellModels[indexPath.row]
    }

    func sectionTitle(section: Int) -> String {
        sections[section].title
    }
}

// MARK: Cell Makers
private extension TaskDetailsViewModel {

    func makeSimpleCellModel() -> SimpleCell.Model {
        .init(
            descriptionText: task.description
        )
    }

    func makeTaskActionsModel() -> TaskActionCell.Model {
        switch taskCategory {
        case .today:
            if task.completed || task.snoozed || task.skipped {
                return makeTaskActionModelEdit()
            } else {
                return makeTaskActionModelComplete()
            }
        case .upcoming:
            return makeTaskActionModelUpcoming()
        }
    }
}

// MARK: Helper Methods

private extension TaskDetailsViewModel {
    func makeTaskActionModelComplete() -> TaskActionCell.Model {
        return .init(
            title: "Complete task",
            isUpcomingTask: false,
            onTap: { [weak self] in
                guard let self = self else { return }
                self.router.dismissModal {
                    let newDeadline = self.task.deadline.adding(days: self.task.interval)
                    let requestData = TaskUpdateRequest(
                        newDeadline: newDeadline,
                        updateType: .complete,
                        task: self.task
                    )
                    self.onAction(.requestUpdate(requestData))
                }
            },
            onTapMoreActions: { [weak self] in
                guard let self = self else { return }
                self.showActionsModal(task: self.task, isPerformed: false)
            }
        )
    }
    func makeTaskActionModelEdit() -> TaskActionCell.Model {
        return .init(
            title: "Add Details",
            isUpcomingTask: false,
            onTap: { [weak self] in
                guard let self = self else { return }

                self.showTaskAddDetailsScreen(task: self.task)
            },
            onTapMoreActions: { [weak self] in
                guard let self = self else { return }

                self.showActionsModal(task: self.task, isPerformed: true)
            }
        )
    }
    func makeTaskActionModelUpcoming() -> TaskActionCell.Model {
        return .init(
            title: "Show Plant",
            isUpcomingTask: true,
            onTap: { [weak self] in
                guard let self = self else { return }
                let viewModel = PlantDetailsViewModel(plant: self.task.plant)
                self.router.push(PlantDetailsViewController(viewModel: viewModel))
            },
            onTapMoreActions: nil
        )
    }
}
// MARK: Router

private extension TaskDetailsViewModel {
    func showActionsModal(task: Task, isPerformed: Bool) {
        let screen = screenFactory.makeActionsModal(
            isPerformed: isPerformed,
            task: task,
            router: router
        ) { [ weak self ] requestData in
            guard let self = self else { return }
            self.onAction(.requestUpdate(requestData))
            self.router.dismissModal()
        }
        router.presentModal(screen)
    }

    func showTaskAddDetailsScreen(task: Task) {
        let screen = screenFactory.makeTaskAddDetailsController(task: task)
        router.presentModal(screen, inMultipleDetents: true, embedInNavigationController: true)
    }
}
