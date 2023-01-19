//
//  Stubs.swift
//  BulbTests
//
//  Created by Sabau Cristina on 02/08/2022.
//

import Foundation
@testable import Bulb

extension Task {
    static func stub(
        id: String = UUID().uuidString,
        taskType: String = "water",
        site: String = "bedroom",
        completed: Bool = false,
        deadline: Date = Date.now,
        description: String = "how to water a plant",
        interval: Int = 2,
        snoozed: Bool = false,
        skipped: Bool = false,
        notes: String? = nil,
        plant: Plant = .stub()
    ) -> Task {
        Task(
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

extension TaskUpdateRequest {
    static func stub(
        newDeadline: Date = Date(timeIntervalSince1970: 123),
        updateType: TaskUpdateAction = .snooze,
        task: Task = .stub()
    ) -> TaskUpdateRequest {
        TaskUpdateRequest(
            newDeadline: newDeadline,
            updateType: updateType,
            task: task)
    }
}

extension Plant {
    static func stub(
        id: String = "some_plant",
        name: String = "Calathea",
        scientificName: String = "Drama",
        lightLevel: LightLevel = .low,
        waterLevel: WaterLevel = .high,
        humidityLevel: HumidityLevel = .low,
        cleanLevel: CleanLevel = .low,
        wateringInterval: Int = 5,
        fertilizingInterval: Int = 20,
        maintenanceLevel: String = "easy",
        careInstructions: String = "caring & love",
        state: String = "bad",
        imageURL: String = "some_url",
        isFavourite: Bool = false,
        plantHeight: String = "10cm-100cm",
        plantWidth: String = "5cm-50cm"
    ) -> Plant {
        Plant(
            id: id,
            name: name,
            scientificName: scientificName,
            lightLevel: lightLevel,
            waterLevel: waterLevel,
            humidityLevel: humidityLevel,
            cleanLevel: cleanLevel,
            wateringInterval: wateringInterval,
            fertilizingInterval: fertilizingInterval,
            maintenanceLevel: maintenanceLevel,
            careInstructions: careInstructions,
            state: state,
            imageURL: imageURL,
            isFavourite: isFavourite,
            plantHeight: plantHeight,
            plantWidth: plantWidth
        )
    }
}
