//
//  HameScreenFactory.swift
//  Bulb
//
//  Created by Sabau Cristina on 09/08/2022.
//

import Foundation
import UIKit

protocol HomeScreenFactoryProtocol: AnyObject {
    func makeTaskDetailsScreen(
        task: Task,
        taskCategory: TaskCategory,
        onAction: @escaping (TaskDetailsViewModel.Action) -> Void
    ) -> UIViewController

    func makeSnoozeModal(
        task: Task,
        onPerformUpdate: @escaping (TaskUpdateRequest) -> Void
    ) -> UIViewController
}

final class HomeScreenFactory: HomeScreenFactoryProtocol {
    func makeTaskDetailsScreen(
        task: Task,
        taskCategory: TaskCategory,
        onAction: @escaping (TaskDetailsViewModel.Action) -> Void
    ) -> UIViewController {
        let viewModel = TaskDetailsViewModel(
            task: task,
            taskCategory: taskCategory,
            onAction: onAction
        )
        return TaskDetailsViewController(
            viewModel: viewModel
        )
    }

    func makeSnoozeModal(
        task: Task,
        onPerformUpdate: @escaping (TaskUpdateRequest) -> Void
    ) -> UIViewController {
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

        let snoozeAction = makeSnoozeAlertAction(with: task, onSnooze: onPerformUpdate)
        alert.addAction(snoozeAction)

        let skipAction = makeSkipAlertAction(with: task, onSkip: onPerformUpdate)
        alert.addAction(skipAction)
        return alert
    }
}

// MARK: - Utils

private extension HomeScreenFactory {
    func makeSnoozeAlertAction(
        with task: Task,
        onSnooze: @escaping (TaskUpdateRequest) -> Void
    ) -> UIAlertAction {
        let snoozeAction = UIAlertAction(
            title: "Snooze 2 days",
            style: .default
        ) { _ in
            let newDeadline = Date.now.adding(days: 2)
            let requestData = TaskUpdateRequest(
                newDeadline: newDeadline,
                updateType: .snooze,
                task: task
            )
            onSnooze(requestData)
        }

        return snoozeAction
    }

    func makeSkipAlertAction(
        with task: Task,
        onSkip: @escaping (TaskUpdateRequest) -> Void
    ) -> UIAlertAction {
        let skipAction = UIAlertAction(
            title: "Skip",
            style: .default
        ) { _ in
            let newDeadline = Date.now.adding(days: task.interval)
            let requestData = TaskUpdateRequest(
                newDeadline: newDeadline,
                updateType: .skip,
                task: task
            )
            onSkip(requestData)
        }

        return skipAction
    }
}
