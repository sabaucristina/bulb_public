//
//  TaskUpdatedTransaction.swift
//  Bulb
//
//  Created by Sabau Cristina on 21/07/2022.
//

import Foundation

struct TaskUpdateRequest: Equatable {
    let newDeadline: Date
    let updateType: TaskUpdateAction
    let task: Task
}
