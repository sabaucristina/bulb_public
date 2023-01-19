//
//  TaskCreateDto.swift
//  Bulb
//
//  Created by Sabau Cristina on 16/07/2022.
//

import Foundation
import FirebaseFirestore

struct TaskCreateDto: Codable {
    let taskType: String
    let site: String
    let completed: Bool
    let deadline: Date
    let description: String
    let interval: Int
    let snoozed: Bool
    let skipped: Bool
    let notes: String?

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
    }
}
