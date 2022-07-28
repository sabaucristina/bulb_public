//
//  FirestoreService.swift
//  Bulb
//
//  Created by Sabau Cristina on 13/05/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

final class FirestoreService {
    static let shared = FirestoreService()
    let database: Firestore
    let tasksCollection: CollectionReference
    var reference: DocumentReference?

    enum Constants {
        static let collectionName: String = "tasks"
        static let dateField: String = "deadline"
    }

    private init() {
        database = Firestore.firestore()
        tasksCollection = database.collection(Constants.collectionName)
    }
}
