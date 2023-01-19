//
//  TaskDetailsFactory.swift
//  Bulb
//
//  Created by Sabau Cristina on 18/08/2022.
//

import Foundation
import UIKit

protocol TaskDetailsFactoryProtocol: AnyObject {
    func makeTaskAddDetailsController(
        task: Task
    ) -> UIViewController

    func makeActionsModal(
        isPerformed: Bool,
        task: Task,
        router: RouterProtocol,
        onPerformUpdate: @escaping (TaskUpdateRequest) -> Void
    ) -> UIViewController
}

final class TaskDetailsFactory: TaskDetailsFactoryProtocol {
    func makeTaskAddDetailsController(
        task: Task
    ) -> UIViewController {
        TaskAddDetailsViewController(task: task)
    }

    func makeActionsModal(
        isPerformed: Bool,
        task: Task,
        router: RouterProtocol,
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

        let showPlant = UIAlertAction(
            title: "Show Plant",
            style: .default,
            handler: { _ in
                let viewModel = PlantDetailsViewModel(plant: task.plant)
                router.push(PlantDetailsViewController(viewModel: viewModel))
            }
        )
        alert.addAction(showPlant)

        if !isPerformed {
            let skip = makeSkipAlertAction(with: task, onSkip: onPerformUpdate)
            alert.addAction(skip)

            let snooze = makeSnoozeAlertAction(with: task, onSnooze: onPerformUpdate)
            alert.addAction(snooze)
        }

        return alert
    }
}

// MARK: Utils

private extension TaskDetailsFactory {
    func makeSnoozeAlertAction(
        with task: Task,
        onSnooze: @escaping (TaskUpdateRequest) -> Void
    ) -> UIAlertAction {
        let snoozeAction = UIAlertAction(
            title: "Snooze 2 days",
            style: .default
        ) { _ in
            let newDeadline = task.deadline.adding(days: 2)
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
            let newDeadline = task.deadline.adding(days: task.interval)
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
