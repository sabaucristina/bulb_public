//
//  TaskServiceMock.swift
//  BulbTests
//
//  Created by Sabau Cristina on 01/08/2022.
//

import Foundation
@testable import Bulb

final class TaskServiceMock: TaskAPIServiceProtocol {
    var getTodaysTasksStub: ((@escaping (Result<[Task], Error>) -> Void) -> Void)!
    func getTodaysTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        getTodaysTasksStub(completion)
    }

    var  getUpcomingTasksStub: ((@escaping (Result<[Task], Error>) -> Void) -> Void)!
    func getUpcomingTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        getUpcomingTasksStub(completion)
    }

    var updateTaskStub: ((String, [String : Any], @escaping (Result<Void, Error>) -> Void) -> Void)!
    func updateTask(with id: String, data: [String : Any], completion: @escaping (Result<Void, Error>) -> Void) {
        updateTaskStub(id, data, completion)
    }

    var performTaskStub: ((TaskUpdateAction, Task, TaskCreateDto, @escaping (Result<String, Error>) -> Void) -> Void)!
    func performTask(updateType: TaskUpdateAction, task: Task, newTask: TaskCreateDto, completion: @escaping ((Result<String, Error>) -> Void)) {
        performTaskStub(updateType, task, newTask, completion)
    }


}
