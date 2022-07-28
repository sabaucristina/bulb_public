//
//  File.swift
//  Bulb
//
//  Created by Sabau Cristina on 12/05/2022.
//

import Foundation
import UIKit

final class HomeScreenViewController: UIViewController {
    private lazy var segmentedControl = makeSegmentedControl()
    private lazy var tableView = UITableView()
    private var taskCategory: TaskCategory = .today

    private var sections = [HomeScreenSectionProtocol]()

    enum Constants {
        static let taskDetailsSheetCornerRadius: CGFloat = 20
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        setupTableView()
        navigationItem.titleView = segmentedControl

        view.addSubview(tableView)
        tableView.pinToSuperviewEdges()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTasks()
    }

    func getTasks() {
        switch taskCategory {
        case .today:
            TaskService.getTodaysTasks { [weak self] result in
                switch result {
                case let .failure(error):
                    self?.view.displayError(error: error)
                case let .success(tasks):
                    let tasks = tasks.filter({
                           !$0.deadline.isToday && !($0.completed || $0.skipped || $0.snoozed) || $0.deadline.isToday
                        }
                    )
                    self?.updateSection(with: tasks, sectionType: .today)
                    self?.tableView.reloadData()
                }
            }
        case .upcoming:
            TaskService.getUpcomingTasks { [weak self] result in
                switch result {
                case let .failure(error):
                    self?.view.displayError(error: error)
                case let .success(tasks):
                    self?.updateSection(with: tasks, sectionType: .upcoming)
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

// MARK: Helper Methods
private extension HomeScreenViewController {
    func updateSection(
        with tasks: [Task],
        sectionType: TaskCategory
    ) {
        if tasks.isEmpty {
            sections = [BannerSection()]
        } else {
            sections = []
            switch sectionType {
            case .today:
                if !tasks.contains(where: { $0.completed == false }) {
                    sections.append(TasksCompletedSection())
                }

                sections.append(
                    contentsOf: makeSiteSection(with: tasks)
                )
            case .upcoming:
                sections.append(
                    contentsOf: makeDeadlineSection(with: tasks)
                )
            }
        }
    }

    func makeSiteSection(with tasks: [Task]) -> [SiteSection] {
        tasks
        .groupBySite()
        .sorted(by: { $0.key.localizedStandardCompare($1.key) == .orderedAscending })
        .map { (key, value) in
            SiteSection(site: key, tasks: value) { [weak self] action in
                self?.handleTaskAction(action: action)
            }
        }
    }

    func makeDeadlineSection(with tasks: [Task]) -> [DeadlineSection] {
        tasks
        .groupByDeadline()
        .sorted(by: { $0.key < $1.key })
        .map { key, value in
            DeadlineSection(deadline: key, tasks: value) { [weak self] action in
                self?.handleTaskAction(action: action)
            }
        }
    }

    func handleTaskAction(action: HomeSectionAction) {
        switch action {
        case let .showTaskDetails(task):
            showTaskDetails(task)
        case let .showSnoozeModal(task):
            showSnoozeModal(task)
        case let .completeTask(task):
            let newDeadline = task.deadline.adding(days: task.interval)
            let requestData = TaskUpdateRequest(
                newDeadline: newDeadline,
                updateType: .complete,
                task: task
            )
            performTask(requestData: requestData)
        }
    }

    func performTask(
        requestData: TaskUpdateRequest
    ) {
        let task = requestData.task
        let taskCreateDto = TaskCreateDto.init(
            taskType: task.taskType,
            site: task.site,
            completed: false,
            deadline: requestData.newDeadline,
            description: task.description,
            interval: task.interval,
            snoozed: false,
            skipped: false,
            notes: task.notes
        )

        TaskService.performTask(
            updateType: requestData.updateType,
            task: task,
            newTask: taskCreateDto
        ) { [weak self] result in
            switch result {
            case .success:
                self?.getTasks()
            case let .failure(error):
                self?.view.displayError(error: error)
            }
        }
    }

    func makeSegmentedControl() -> UISegmentedControl {
        let segment = UISegmentedControl(
            items: TaskCategory.allCases.map { $0.type.capitalized }
        )
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = taskCategory.rawValue
        segment.addTarget(self, action: #selector(segmentHasChanged), for: .valueChanged)

        return segment
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            SimpleHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SimpleHeaderView.identifierName
        )
        tableView.register(
            TaskCellView.self,
            forCellReuseIdentifier: TaskCellView.identifierName
        )
        tableView.register(
            SimpleBannerCell.self,
            forCellReuseIdentifier: SimpleBannerCell.identifierName
        )

        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc
    func segmentHasChanged() {
        if let task = TaskCategory(rawValue: segmentedControl.selectedSegmentIndex) {
            taskCategory = task
            getTasks()
        }
    }
}

// MARK: TableView DataSource & Delegate
extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        sections.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        sections[section].numberOfItems
    }
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let headerModel = sections[section].headerModel else {
            return nil
        }

        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SimpleHeaderView.identifierName
        )
        (header as? SimpleHeaderView)?.update(with: headerModel)

        return header
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: UITableViewCell
        switch sections[indexPath.section].cellModel(for: indexPath.item) {
        case let .task(model):
            cell = tableView.dequeueReusableCell(
                withIdentifier: TaskCellView.identifierName,
                for: indexPath
            )
            (cell as? TaskCellView)?.update(with: model)
        case let .banner(model):
            cell = tableView.dequeueReusableCell(
                withIdentifier: SimpleBannerCell.identifierName,
                for: indexPath
            )
            (cell as? SimpleBannerCell)?.update(with: model)
        case let .tasksCompleted(model):
            cell = tableView.dequeueReusableCell(
                withIdentifier: SimpleBannerCell.identifierName,
                for: indexPath
            )
            (cell as? SimpleBannerCell)?.update(with: model)
        }

        if indexPath.row != sections[indexPath.section].numberOfItems - 1 {
            cell.separatorInset = UIEdgeInsets.init(
                top: 0.0,
                left: HorizontalSpacing.pt86,
                bottom: 0.0,
                right: HorizontalSpacing.pt16
            )
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        sections[indexPath.section].onTap(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Router
private extension HomeScreenViewController {
    func showTaskDetails(_ task: Task) {
        let taskDetailsController = TaskDetailsViewController(
            task: task,
            taskCategory: taskCategory,
            onTaskUpdated: { [ weak self ] in
                self?.getTasks()
            },
            onTaskAction: { [ weak self ] requestData in
                self?.performTask(
                    requestData: requestData
                )
            }
        )
        let nav = UINavigationController(rootViewController: taskDetailsController)

        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = Constants.taskDetailsSheetCornerRadius
        }

        present(nav, animated: true, completion: nil)
    }

    func showSnoozeModal(_ task: Task) {
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

        let snoozeAction = makeSnoozeAlertAction(with: task)
        alert.addAction(snoozeAction)

        let skipAction = makeSkipAlertAction(with: task)
        alert.addAction(skipAction)

        present(alert, animated: true, completion: nil)
    }

    func makeSnoozeAlertAction(with task: Task) -> UIAlertAction {
        let snoozeAction = UIAlertAction(
            title: "Snooze 2 days",
            style: .default
        ) { [weak self] _ in
            let newDeadline = Date.now.adding(days: 2)
            let requestData = TaskUpdateRequest(
                newDeadline: newDeadline,
                updateType: .snooze,
                task: task
            )
            self?.performTask(requestData: requestData)
        }

        return snoozeAction
    }

    func makeSkipAlertAction(with task: Task) -> UIAlertAction {
        let skipAction = UIAlertAction(
            title: "Skip",
            style: .default
        ) { [weak self] _ in
            let newDeadline = Date.now.adding(days: task.interval)
            let requestData = TaskUpdateRequest(
                newDeadline: newDeadline,
                updateType: .skip,
                task: task
            )
            self?.performTask(requestData: requestData)
        }

        return skipAction
    }
}
