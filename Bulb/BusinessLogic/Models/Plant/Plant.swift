//
//  Plant.swift
//  Bulb
//
//  Created by Sabau Cristina on 24/05/2022.
//

import Foundation
import UIKit

struct Plant: Equatable {
    enum LightLevel: String {
        case low
        case medium
        case high
    }

    enum WaterLevel: String {
        case low
        case medium
        case high
    }

    enum HumidityLevel: String {
        case low
        case medium
        case high
    }

    enum CleanLevel: String {
        case low
        case medium
        case high
    }

    let id: String
    let name: String
    let scientificName: String
    let lightLevel: LightLevel
    let waterLevel: WaterLevel
    let humidityLevel: HumidityLevel
    let cleanLevel: CleanLevel
    let wateringInterval: Int
    let fertilizingInterval: Int
    let maintenanceLevel: String
    let careInstructions: String
    let state: String
    let imageURL: String
    let isFavourite: Bool
    let plantHeight: String
    let plantWidth: String
}

extension Plant.LightLevel {
    var image: Image {
        switch self {
        case .low:
            return .cloud
        case .medium:
            return .cloudSun
        case .high:
            return .sunMax
        }
    }

    var instruction: String {
        switch self {
        case .low:
            return "Shade - indirect light"
        case .medium:
            return "Part sunt, part shade - indirect light"
        case .high:
            return "Full sun - direct light"
        }
    }

    var minimumIdealTemparature: Int {
        switch self {
        case .low:
            return 0
        case .medium:
            return 5
        case .high:
            return 5
        }
    }

    var maximumIdealTemparature: Int {
        switch self {
        case .low:
            return 25
        case .medium:
            return 28
        case .high:
            return 28
        }
    }

    var hardinessZone: Int {
        switch self {
        case .low:
            return 0
        case .medium:
            return 0
        case .high:
            return 5
        }
    }
}

extension Plant.WaterLevel {
    var image: Image {
        switch self {
        case .low:
            return .drop
        case .medium:
            return .mediumWaterLevel
        case .high:
            return .highWaterLevel
        }
    }

    var instruction: String {
        switch self {
        case .low:
            return "Water when soil is dried up"
        case .medium:
            return "Water when the top layer is dry"
        case .high:
            return "High demand - Keep the soil moist"
        }
    }
}

extension Plant.HumidityLevel {
    var instruction: String {
        switch self {
        case .low:
            return "This plant is doing well in a dry place"
        case .medium:
            return "This plant likes humidity but is not necessary"
        case .high:
            return "This plant needs a lot of humidity"
        }
    }
}

extension Plant.CleanLevel {
    var instruction: String {
        switch self {
        case .low:
            return "No need to be cleaned"
        case .medium:
            return "Clean the leaves every 3 month"
        case .high:
            return "Clean the leaves every 1 months"
        }
    }
}
