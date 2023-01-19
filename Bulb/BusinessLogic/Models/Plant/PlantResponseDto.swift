//
//  PlantResponseDto.swift
//  Bulb
//
//  Created by Sabau Cristina on 20/09/2022.
//

import Foundation

struct PlantResponseDto: Decodable {
    let name: String
    let scientificName: String
    let lightLevel: LightLevelDto
    let waterLevel: WaterLevelDto
    let humidityLevel: HumidityLevelDto
    let cleanLevel: CleanLevelDto
    let wateringInterval: Int
    let fertilizingInterval: Int
    let maintenanceLevel: String
    let careInstructions: String
    let state: String
    let imageURL: String
    let isFavourite: Bool
    let plantHeight: String
    let plantWidth: String

    enum CodingKeys: String, CodingKey {
        case name
        case scientificName = "scientific_name"
        case lightLevel = "light_level"
        case waterLevel = "water_level"
        case humidityLevel = "humidity_level"
        case cleanLevel = "clean_level"
        case wateringInterval = "watering_interval"
        case fertilizingInterval = "fertilizing_interval"
        case maintenanceLevel = "maintenance_level"
        case careInstructions = "care_instructions"
        case state
        case imageURL = "image_url"
        case isFavourite = "is_favourite"
        case plantHeight = "plant_height"
        case plantWidth = "plant_width"
    }

    func toDomain(with id: String) -> Plant? {
        return .init(
            id: id,
            name: name,
            scientificName: scientificName,
            lightLevel: lightLevel.toDomain(),
            waterLevel: waterLevel.toDomain(),
            humidityLevel: humidityLevel.toDomain(),
            cleanLevel: cleanLevel.toDomain(),
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

extension PlantResponseDto {
    enum LightLevelDto: String, Decodable {
        case low
        case medium
        case high

        func toDomain() -> Plant.LightLevel {
            switch self {
            case .low:
                return .low
            case .medium:
                return .medium
            case .high:
                return .high
            }
        }
    }

    enum WaterLevelDto: String, Decodable {
        case low
        case medium
        case high

        func toDomain() -> Plant.WaterLevel {
            switch self {
            case .low:
                return .low
            case .medium:
                return .medium
            case .high:
                return .high
            }
        }
    }

    enum HumidityLevelDto: String, Decodable {
        case low
        case medium
        case high

        func toDomain() -> Plant.HumidityLevel {
            switch self {
            case .low:
                return .low
            case .medium:
                return .medium
            case .high:
                return .high
            }
        }
    }

    enum CleanLevelDto: String, Decodable {
        case low
        case medium
        case high

        func toDomain() -> Plant.CleanLevel {
            switch self {
            case .low:
                return .low
            case .medium:
                return .medium
            case .high:
                return .high
            }
        }
    }
}
