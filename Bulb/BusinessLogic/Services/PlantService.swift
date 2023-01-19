//
//  PlantService.swift
//  Bulb
//
//  Created by Sabau Cristina on 20/09/2022.
//

import Foundation
import FirebaseFirestore

protocol PlantServiceProtocol: AnyObject {
    typealias FetchDataCompletion = (Result<[Plant], Error>) -> Void
    typealias UpdateDataCompletion = (Result<Plant, Error>) -> Void

    func getPlants(
        completion: @escaping FetchDataCompletion
    )

    func updateIsFavourite(
        plant: Plant,
        completion: @escaping UpdateDataCompletion
    )
    func search(
        searchKey: String,
        category: PlantCategory,
        completion: @escaping FetchDataCompletion
    )
}

final class PlantService: PlantServiceProtocol {
    private let firebaseDB = FirestoreService.shared

    func getPlants(
        completion: @escaping FetchDataCompletion
    ) {
        firebaseDB
            .plantsCollection
            .getDocuments { querySnapshot, error in
                self.getData(
                    querySnapshot: querySnapshot,
                    error: error,
                    completion: completion
                )
            }
    }

    func search(
        searchKey: String,
        category: PlantCategory,
        completion: @escaping FetchDataCompletion
    ) {
        firebaseDB
            .plantsCollection
            .whereCategory(is: category)
            .search(byName: searchKey)
            .getDocuments { querySnapshot, error in
                self.getData(
                    querySnapshot: querySnapshot,
                    error: error,
                    completion: completion
                )
            }
    }

    func updateIsFavourite(
        plant: Plant,
        completion: @escaping UpdateDataCompletion
    ) {
        let reference = firebaseDB.plantsCollection.document(plant.id)
        let database = firebaseDB.database

        database.runTransaction(
            // swiflint:disable:next opening_brace
            { transaction, errorPointer in
                do {
                    let existingPlant = try transaction
                        .getDocument(reference)
                        .data(as: PlantResponseDto.self)

                    transaction.updateData(
                        [Query.Field.isFavourite: !existingPlant.isFavourite],
                        forDocument: reference
                    )
                } catch let error as NSError {
                    errorPointer?.pointee = error
                }

                return nil
            },
            completion: { _, error in
                if let error = error {
                    return completion(.failure(error))
                }
                self.getPlant(id: plant.id, completion: completion)
            }
        )
    }

    private func getPlant(
        id: String,
        completion: @escaping (Result<Plant, Error>) -> Void
    ) {
        firebaseDB
            .plantsCollection
            .document(id)
            .getDocument(
                as: PlantResponseDto.self,
                completion: { result in
                    let newResult: Result<Plant, Error> = result.flatMap {
                        guard let domain = $0.toDomain(with: id) else {
                            return .failure(ApiError.somethingWentWrong)
                        }
                        return .success(domain)
                    }
                    completion(newResult)
                }
            )
    }
}

private extension Query {
    enum Field {
        static let name: String = "name"
        static let isFavourite: String = "is_favourite"
        static let state: String = "state"
    }
    func whereCategory(is category: PlantCategory) -> Query {
        switch category {
        case .all:
            return self
        case .favourites:
            return self.whereField(Field.isFavourite, isEqualTo: true)
        case .badCondition, .goodCondition:
            return self.whereField(Field.state, isEqualTo: category.value)
        }
    }

    func search(byName name: String) -> Query {
        self
            .whereField(Field.name, isGreaterThanOrEqualTo: name)
            .whereField(Field.name, isLessThanOrEqualTo: name + "z")
    }
}

private extension PlantService {
    func getData(
        querySnapshot: QuerySnapshot?,
        error: Error?,
        completion: @escaping FetchDataCompletion
    ) {
        if let error = error {
            return completion(.failure(error))
        }

        guard let querySnapshot = querySnapshot else {
            return completion(.failure(ApiError.somethingWentWrong))
        }
        do {
            let plants = try querySnapshot.documents.compactMap {
                let response = try $0.data(as: PlantResponseDto.self)
                return response.toDomain(with: $0.documentID)
            } as [Plant]
            completion(.success(plants))
        } catch {
            completion(.failure(error))
        }
    }
}
