//
//  HomeScreenFactoryMock.swift
//  BulbTests
//
//  Created by Sabau Cristina on 09/08/2022.
//

import Foundation
@testable import Bulb
import UIKit

final class HomeScreenFactoryMock: HomeScreenFactoryProtocol {

    var makeTaskDetailsScreenStub: ((
        Task,
        TaskCategory,
        @escaping (TaskDetailsViewModel.Action) -> Void
    ) -> UIViewController)!
    func makeTaskDetailsScreen(
        task: Task,
        taskCategory: TaskCategory,
        onAction: @escaping (TaskDetailsViewModel.Action) -> Void
    ) -> UIViewController {
        makeTaskDetailsScreenStub(task, taskCategory, onAction)
    }

    var makeSnoozeModalStub: ((
        Task,
        @escaping (TaskUpdateRequest) -> Void
    ) -> UIViewController)!
    func makeSnoozeModal(
        task: Task,
        onPerformUpdate: @escaping (TaskUpdateRequest) -> Void
    ) -> UIViewController {
        makeSnoozeModalStub(task, onPerformUpdate)
    }
}
