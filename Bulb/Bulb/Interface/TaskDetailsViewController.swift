//
//  TaskDetailsViewController.swift
//  Bulb
//
//  Created by Sabau Cristina on 14/06/2022.
//

import Foundation
import UIKit

final class TaskDetailsViewController: UITableViewController {

    enum SectionType: Int, CaseIterable {
        case taskInstructions
        case taskDetails
    }

    struct Section {
        let type: SectionType
        let title: String
        let cellModels: [CellModel]
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

    private var cellModels = [CellModel]()
    private var sections = [Section]()
    private var task: Task
    private let taskCategory: TaskCategory
    private let onTaskUpdated: () -> Void
    private let onTaskAction: (TaskUpdateRequest) -> Void

    init(
        task: Task,
        taskCategory: TaskCategory,
        onTaskUpdated: @escaping () -> Void,
        onTaskAction: @escaping (TaskUpdateRequest) -> Void
    ) {
        self.task = task
        self.taskCategory = taskCategory
        self.onTaskUpdated = onTaskUpdated
        self.onTaskAction = onTaskAction
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupTableView()
        reloadData()
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
}

// MARK: Setup UI
private extension TaskDetailsViewController {
    func setupNavigationItems() {
        title = task.taskType.capitalized + " - " + task.site.capitalized
        navigationItem.rightBarButtonItem = .init(
            image: Image.close,
            style: .plain,
            target: self,
            action: #selector(closeSheet)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    func setupTableView() {
        tableView.register(
            SimpleCell.self,
            forCellReuseIdentifier: SimpleCell.identifierName
        )
        tableView.register(
            TaskActionCell.self,
            forCellReuseIdentifier: TaskActionCell.identifierName
        )
        tableView.register(
            SimpleHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SimpleHeaderView.identifierName
        )

        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
    }
}

// MARK: Cell Makers
private extension TaskDetailsViewController {

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
private extension TaskDetailsViewController {
    func makeTaskActionModelComplete() -> TaskActionCell.Model {
        return .init(
            title: "Complete task",
            isUpcomingTask: false,
            onTap: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    let newDeadline = self.task.deadline.adding(days: self.task.interval)
                    let requestData = TaskUpdateRequest(
                        newDeadline: newDeadline,
                        updateType: .complete,
                        task: self.task
                    )
                    self.onTaskAction(requestData)
                }
            },
            onTapMoreActions: { [weak self] in
                guard let self = self else { return }
                self.showActions(isPerformed: false)
            }
        )
    }
    func makeTaskActionModelEdit() -> TaskActionCell.Model {
        return .init(
            title: "Add Details",
            isUpcomingTask: false,
            onTap: { [weak self] in
                guard let self = self else { return }

                let taskCtl = TaskAddDetailsViewController(task: self.task)
                let nav = UINavigationController(rootViewController: taskCtl)

                nav.modalPresentationStyle = .pageSheet
                if let sheet = nav.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.selectedDetentIdentifier = .medium
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = true
                    sheet.preferredCornerRadius = 20
                }

                self.present(nav, animated: true, completion: nil)
            },
            onTapMoreActions: { [weak self] in
                guard let self = self else { return }

                self.showActions(isPerformed: true)
            }
        )
    }
    func makeTaskActionModelUpcoming() -> TaskActionCell.Model {
        return .init(
            title: "Show Plant",
            isUpcomingTask: true,
            onTap: { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            },
            onTapMoreActions: nil
        )
    }

    func showActions(isPerformed: Bool) {
        let alert = UIAlertController(
            title: "Actions",
            message: "",
            preferredStyle: .actionSheet
        )

        let cancel = UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        )
        alert.addAction(cancel)

        let showPlant = UIAlertAction(
            title: "Show Plant",
            style: .default,
            handler: nil
        )
        alert.addAction(showPlant)

        if !isPerformed {
            let skip = makeSkipAlertAction(with: task)
            alert.addAction(skip)

            let snooze = makeSnoozeAlertAction(with: task)
            alert.addAction(snooze)
        }

        present(alert, animated: true)
    }

    func makeSnoozeAlertAction(with task: Task) -> UIAlertAction {
        let snoozeAction = UIAlertAction(
            title: "Snooze 2 days",
            style: .default
        ) { [weak self] _ in
            let newDeadline = task.deadline.adding(days: 2)
            let requestData = TaskUpdateRequest(
                newDeadline: newDeadline,
                updateType: .snooze,
                task: task
            )
            self?.onTaskAction(requestData)
            self?.dismiss(animated: true)
        }

        return snoozeAction
    }

    func makeSkipAlertAction(with task: Task) -> UIAlertAction {
        let skipAction = UIAlertAction(
            title: "Skip",
            style: .default
        ) { [weak self] _ in
            let newDeadline = task.deadline.adding(days: task.interval)
            let requestData = TaskUpdateRequest(
                newDeadline: newDeadline,
                updateType: .skip,
                task: task
            )
            self?.onTaskAction(requestData)
            self?.dismiss(animated: true)
        }

        return skipAction
    }

    @objc
    func closeSheet() {
        dismiss(animated: true)
    }
}

extension TaskDetailsViewController {
    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        sections.count
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        sections[section].cellModels.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cellModel = sections[indexPath.section].cellModels[indexPath.row]

        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellModel.identifier,
            for: indexPath
        )

        switch cellModel {
        case .simple(let model):
            (cell as? SimpleCell)?.update(with: model)
        case .text(let model):
            (cell as? TextViewCell)?.update(with: model)
        case .actions(let model):
            (cell as? TaskActionCell)?.update(with: model)
        }

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {

        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SimpleHeaderView.identifierName
        )
        let title = sections[section].title
        let model = SimpleHeaderView.Model.init(title: title)

        (header as? SimpleHeaderView)?.update(with: model)

        return header
    }
}
