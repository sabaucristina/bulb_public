//
//  TaskModel.swift
//  Bulb
//
//  Created by Sabau Cristina on 24/05/2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

struct TaskResponseDto: Codable {
    let taskType: String
    let site: String
    let completed: Bool
    let deadline: Date
    let description: String
    let interval: Int
    let snoozed: Bool
    let skipped: Bool
    let notes: String?
    let plant: DocumentReference

    enum CodingKeys: String, CodingKey {
        case taskType = "task_type"
        case site
        case completed
        case deadline
        case description
        case interval
        case snoozed
        case skipped
        case notes
        case plant
    }

    func toDomain(with id: String, plant: Plant) -> Task {
        .init(
            id: id,
            taskType: taskType,
            site: site,
            completed: completed,
            deadline: deadline,
            description: description,
            interval: interval,
            snoozed: snoozed,
            skipped: skipped,
            notes: notes,
            plant: plant
        )
    }
}
