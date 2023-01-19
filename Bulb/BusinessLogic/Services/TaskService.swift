//
//  TaskService.swift
//  Bulb
//
//  Created by Sabau Cristina on 24/05/2022.
//

import Foundation
import FirebaseFirestore

protocol TaskAPIServiceProtocol: AnyObject {
    func getTodaysTasks(
        completion: @escaping (Result<[Task], Error>) -> Void
    )
    func getUpcomingTasks(
        completion: @escaping (Result<[Task], Error>) -> Void
    )
    func updateTask(
        with id: String,
        data: [String: Any],
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func performTask(
        updateType: TaskUpdateAction,
        task: Task,
        newTask: TaskCreateDto,
        completion: @escaping ((Result<String, Error>) -> Void)
    )
}

final class TaskService: TaskAPIServiceProtocol {
    private let firestoreDB = FirestoreService.shared
    enum Constants {
        static let dateField: String = "deadline"
    }

    func performTask(
        updateType: TaskUpdateAction,
        task: Task,
        newTask: TaskCreateDto,
        completion: @escaping ((Result<String, Error>) -> Void)
    ) {
        let reference = firestoreDB.tasksCollection.document(task.id)
        let database = firestoreDB.database

        database.runTransaction(
            // swiflint:disable:next opening_brace
            { (transaction, errorPointer) -> Any? in
                let document: DocumentSnapshot
                let newDocument = self.firestoreDB.tasksCollection.document()
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

    func updateTask(
        with id: String,
        data: [String: Any],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        firestoreDB
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

    func getTodaysTasks(
        completion: @escaping (Result<[Task], Error>) -> Void
    ) {
        firestoreDB
            .tasksCollection
            .whereField(Constants.dateField, isLessThanOrEqualTo: Date().endOfDay)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    return completion(.failure(error))
                }
                guard let querySnapshot = querySnapshot else {
                    return completion(.failure(ApiError.somethingWentWrong))
                }
                var tasks = [Task]()
                let group = DispatchGroup()
                do {
                    try querySnapshot.documents.forEach {
                        let taskResponse = try $0.data(as: TaskResponseDto.self)
                        let taskID = $0.documentID
                        group.enter()
                        self.getPlant(plantReference: taskResponse.plant) { result in
                            switch result {
                            case .failure:
                                break
                            case .success(let plant):
                                let task = taskResponse.toDomain(
                                    with: taskID,
                                    plant: plant
                                )
                                tasks.append(task)
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        completion(.success(tasks))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
    }

    func getUpcomingTasks(
        completion: @escaping (Result<[Task], Error>) -> Void
    ) {
        firestoreDB
            .tasksCollection
            .whereField(Constants.dateField, isGreaterThan: Date().endOfDay)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    return completion(.failure(error))
                }
                guard let querySnapshot = querySnapshot else {
                    return completion(.failure(ApiError.somethingWentWrong))
                }
                var tasks = [Task]()
                let group = DispatchGroup()
                do {
                    try querySnapshot.documents.forEach {
                        let taskResponse = try $0.data(as: TaskResponseDto.self)
                        let taskID = $0.documentID
                        group.enter()
                        self.getPlant(plantReference: taskResponse.plant) { result in
                            switch result {
                            case .failure:
                                break
                            case .success(let plant):
                                let task = taskResponse.toDomain(
                                    with: taskID,
                                    plant: plant
                                )
                                tasks.append(task)
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        completion(.success(tasks))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
    }

    private func getPlant(
        plantReference: DocumentReference,
        completion: @escaping (Result<Plant, Error>) -> Void
    ) {
        plantReference
            .getDocument(
                as: PlantResponseDto.self,
                completion: { result in
                    let newResult: Result<Plant, Error> = result.flatMap {
                        guard let domain = $0.toDomain(with: plantReference.documentID) else {
                            return .failure(ApiError.somethingWentWrong)
                        }
                        return .success(domain)
                    }
                    completion(newResult)
                }
            )
    }
}

enum ApiError: Error, LocalizedError {
    case somethingWentWrong
    case unableToRetriveField(DocumentSnapshot)
    case notFound

    var errorDescription: String? {
        switch self {
        case .somethingWentWrong:
            return "Something went wrong"
        case let .unableToRetriveField(document):
            return "Unable to retrieve field from snapshot \(document)"
        case .notFound:
            return "404"
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
