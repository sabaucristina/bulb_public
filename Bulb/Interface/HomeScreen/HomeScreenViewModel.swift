//
//  HomeScreenViewModel.swift
//  Bulb
//
//  Created by Sabau Cristina on 28/07/2022.
//

import Foundation

final class HomeScreenViewModel {
    private var sections = [HomeScreenSectionProtocol]()
    private let taskService: TaskAPIServiceProtocol
    private let router: RouterProtocol
    private let screenFactory: HomeScreenFactoryProtocol
    private let firebaseAuthService: FirebaseAuthServiceProtocol
    var taskCategory: TaskCategory = .today
    var onAction: ((Action) -> Void)?

    init(
        router: RouterProtocol,
        screenFactory: HomeScreenFactoryProtocol,
        taskService: TaskAPIServiceProtocol,
        firebaseAuthService: FirebaseAuthServiceProtocol
    ) {
        self.router = router
        self.screenFactory = screenFactory
        self.taskService = taskService
        self.firebaseAuthService = firebaseAuthService
    }

    convenience init() {
        self.init(
            router: Router(),
            screenFactory: HomeScreenFactory(),
            taskService: TaskService(),
            firebaseAuthService: FirebaseAuthService()
        )
    }

    enum Action: Equatable {
        case handleError(NSError)
        case reload
    }
}

// MARK: - TableView DataSource

extension HomeScreenViewModel {
    func numberOfSections() -> Int {
        sections.count
    }
    func numberOfRowsInSection(section: Int) -> Int {
        sections[section].numberOfItems
    }
    func headerModel(section: Int) -> SimpleHeaderView.Model? {
        sections[section].headerModel
    }
    func cellModel(at index: IndexPath) -> TableViewItemModel {
        sections[index.section].cellModel(for: index.item)
    }
    func onTapCell(at index: IndexPath) {
        sections[index.section].onTap(index: index.row)
    }
}

// MARK: Firebase Auth

extension HomeScreenViewModel {
    func logOut() {
        firebaseAuthService.logOut()
    }
}

// MARK: - Task API

extension HomeScreenViewModel {
    func refreshTasks() {
        switch taskCategory {
        case .today:
            updateTodaysTasks()
        case .upcoming:
            updateUpcomingTasks()
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

        taskService.performTask(
            updateType: requestData.updateType,
            task: task,
            newTask: taskCreateDto
        ) { [weak self] result in
            switch result {
            case .success:
                self?.refreshTasks()
            case let .failure(error):
                self?.onAction?(.handleError(error as NSError))
            }
        }
    }
}

// MARK: Helper Methods

private extension HomeScreenViewModel {
    func updateTodaysTasks() {
        taskService.getTodaysTasks { [weak self] result in
            switch result {
            case let .failure(error):
                self?.onAction?(.handleError(error as NSError))
            case let .success(tasks):
                let tasks = tasks.filter {
                    if $0.deadline.isToday { return true }
                    return $0.wasNotModified
                }
                self?.updateSections(with: tasks, taskCategory: .today)
                self?.onAction?(.reload)
            }
        }
    }

    func updateUpcomingTasks() {
        taskService.getUpcomingTasks { [weak self] result in
            switch result {
            case let .failure(error):
                self?.onAction?(.handleError(error as NSError))
            case let .success(tasks):
                self?.updateSections(with: tasks, taskCategory: .upcoming)
                self?.onAction?(.reload)
            }
        }
    }
}

// MARK: Sections

private extension HomeScreenViewModel {
    func updateSections(
        with tasks: [Task],
        taskCategory: TaskCategory
    ) {
        if tasks.isEmpty {
            return sections = [BannerSection()]
        }
        switch taskCategory {
        case .today:
            sections = makeTodaySections(with: tasks)
        case .upcoming:
            sections = makeDeadlineSections(with: tasks)
        }
    }

    func makeTodaySections(with tasks: [Task]) -> [HomeScreenSectionProtocol] {
        [
            makeTasksCompletedSection(with: tasks)
        ].compactMap { $0 }
        +  makeSiteSections(with: tasks)
    }

    func makeTasksCompletedSection(with tasks: [Task]) -> HomeScreenSectionProtocol? {
        let areAllTasksCompleted = tasks.allSatisfy { $0.completed }
        guard areAllTasksCompleted else { return nil }
        return TasksCompletedSection()
    }

    func makeSiteSections(with tasks: [Task]) -> [HomeScreenSectionProtocol] {
        tasks
        .groupBySite()
        .sorted(by: { $0.key.localizedStandardCompare($1.key) == .orderedAscending })
        .map { (key, value) in
            SiteSection(site: key, tasks: value) { [weak self] action in
                self?.handleTaskAction(action: action)
            }
        }
    }

    func makeDeadlineSections(with tasks: [Task]) -> [HomeScreenSectionProtocol] {
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
            showUpdateActionsModal(task)
        case let .completeTask(task):
            let newDeadline = task.deadline.adding(days: task.interval)
            let requestData = TaskUpdateRequest(
                newDeadline: newDeadline,
                updateType: .complete,
                task: task
            )
            self.performTask(requestData: requestData)
        }
    }
}

// MARK: - Router
private extension HomeScreenViewModel {
    func showTaskDetails(_ task: Task) {
        let screen = screenFactory.makeTaskDetailsScreen(
            task: task,
            taskCategory: taskCategory
        ) { [weak self] action in
            switch action {
            case let .requestUpdate(updateRequest):
                self?.performTask(requestData: updateRequest)
            }
        }
        router.presentModal(
            screen,
            inMultipleDetents: true,
            embedInNavigationController: true
        )
    }

    func showUpdateActionsModal(_ task: Task) {
        let screen = screenFactory.makeSnoozeModal(task: task) { [weak self] request in
            self?.performTask(requestData: request)
        }
        router.presentModal(screen)
    }
}
