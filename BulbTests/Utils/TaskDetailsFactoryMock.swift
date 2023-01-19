//
//  TaskDetailsFactoryMock.swift
//  BulbTests
//
//  Created by Sabau Cristina on 19/08/2022.
//

@testable import Bulb
import UIKit

final class TaskDetailsFactoryMock: TaskDetailsFactoryProtocol {
    
    var makeTaskAddDetailsControllerStub: ((Task) -> UIViewController)!
    func makeTaskAddDetailsController(
        task: Task
    ) -> UIViewController {
        makeTaskAddDetailsControllerStub(task)
    }

    var makeActionsModalStub: ((
        Bool,
        Task,
        RouterProtocol,
        @escaping (TaskUpdateRequest) -> Void
    ) -> UIViewController)!
    func makeActionsModal(
        isPerformed: Bool,
        task: Task,
        router: RouterProtocol,
        onPerformUpdate: @escaping (TaskUpdateRequest) -> Void
    ) -> UIViewController {
        makeActionsModalStub(isPerformed, task, router, onPerformUpdate)
    }
}
