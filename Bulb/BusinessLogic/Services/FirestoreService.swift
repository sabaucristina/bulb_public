//
//  FirestoreService.swift
//  Bulb
//
//  Created by Sabau Cristina on 13/05/2022.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import FirebaseStorageUI

final class FirestoreService {
    static let shared = FirestoreService()
    let database: Firestore
    let storage: Storage
    let tasksCollection: CollectionReference
    let plantsCollection: CollectionReference
    var reference: DocumentReference?

    enum Constants {
        static let tasksCollectionName: String = "tasks"
        static let plantsCollectionName: String = "plants"
        static let dateField: String = "deadline"
        static let storageURL: String = "gs://bulb-f2020.appspot.com"
    }

    private init() {
        database = Firestore.firestore()
        storage = Storage.storage()
        tasksCollection = database.collection(Constants.tasksCollectionName)
        plantsCollection = database.collection(Constants.plantsCollectionName)
    }

    func createPlantImageRef(imageURL: String) -> StorageReference? {
        if imageURL.hasPrefix(Constants.storageURL) {
            return storage.reference(forURL: imageURL)
        }
        return nil
    }
}
