//
//  TaskService.swift
//  Bulb
//
//  Created by Sabau Cristina on 24/05/2022.
//

import Foundation
import FirebaseFirestore

final class TaskService {

    enum Constants {
        static let dateField: String = "deadline"
    }

    static func performTask(
        updateType: TaskUpdateAction,
        task: Task,
        newTask: TaskCreateDto,
        completion: @escaping ((Result<String, Error>) -> Void)
    ) {
        let reference = FirestoreService.shared.tasksCollection.document(task.id)
        let database = FirestoreService.shared.database

        database.runTransaction(
            // swiflint:disable:next opening_brace
            { (transaction, errorPointer) -> Any? in
                let document: DocumentSnapshot
                let newDocument = FirestoreService.shared.tasksCollection.document()
                let state = updateType.state
                do {
                    try document = transaction.getDocument(reference)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                guard let isStatePerformed = document.data()?[state] as? Bool else {
                    errorPointer?.pointee = ApiError.unableToRetriveField(document) as NSError
                    return nil
                }

                if isStatePerformed {
                    return "Task has been already \(state)!"
                } else {
                    transaction.updateData(
                        [state: true, "deadline": Date.now], forDocument: reference
                    )
                    do {
                        try transaction.setData(from: newTask, forDocument: newDocument)
                    } catch let addTaskError as NSError {
                        errorPointer?.pointee = addTaskError
                        return nil
                    }

                    return "Task \(state) succesfully!"
                }
            },
            completion: { (message, error) in
                if let error = error {
                    completion(.failure(error))
                } else {
                    let successMessage = (message as? String) ?? ""
                    completion(.success(successMessage))
                }
            }
        )
    }

    static func updateTask(
        with id: String,
        data: [String: Any],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        FirestoreService.shared
            .tasksCollection
            .document(id)
            .updateData(data) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }

    static func getTodaysTasks(
        completion: @escaping (Result<[Task], Error>) -> Void
    ) {
        FirestoreService.shared
            .tasksCollection
            .whereField(Constants.dateField, isLessThanOrEqualTo: Date().endOfDay)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    return completion(.failure(error))
                }
                guard let querySnapshot = querySnapshot else {
                    return completion(.failure(ApiError.somethingWentWrong))
                }
                do {
                    let tasks = try querySnapshot.documents.map {
                        let taskResponse = try $0.data(as: TaskResponseDto.self)
                        return taskResponse.toDomain(with: $0.documentID)
                    } as [Task]
                    completion(.success(tasks))
                } catch {
                    completion(.failure(error))
                }
            }
    }

    static func getUpcomingTasks(
        completion: @escaping (Result<[Task], Error>) -> Void
    ) {
        FirestoreService.shared
            .tasksCollection
            .whereField(Constants.dateField, isGreaterThan: Date().endOfDay)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    return completion(.failure(error))
                }
                guard let querySnapshot = querySnapshot else {
                    return completion(.failure(ApiError.somethingWentWrong))
                }
                do {
                    let tasks = try querySnapshot.documents.map {
                        let taskResponse = try $0.data(as: TaskResponseDto.self)
                        return taskResponse.toDomain(with: $0.documentID)
                    } as [Task]
                    completion(.success(tasks))
                } catch {
                    completion(.failure(error))
                }
            }
    }
}

enum ApiError: Error, LocalizedError {
    case somethingWentWrong
    case unableToRetriveField(DocumentSnapshot)

    var errorDescription: String? {
        switch self {
        case .somethingWentWrong:
            return "Something went wrong"
        case let .unableToRetriveField(document):
            return "Unable to retrieve field from snapshot \(document)"
        }
    }
}

extension Date {
    var endOfDay: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var isToday: Bool {
        return ((self > Date().startOfDay) && (self < Date().endOfDay))
    }
}
