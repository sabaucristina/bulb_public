//
//  Image.swift
//  Bulb
//
//  Created by Sabau Cristina on 27/04/2022.
//

import Foundation
import UIKit

enum Image {
    case homeScreenBackground
    case homeIcon
    case plantIcon
    case searchIcon
    case checkmarkCircle
    case checkmarkFill
    case circle
    case snooze
    case close
    case moreOptions
    case clock
    case unknown
    case cloud
    case cloudSun
    case sunMax
    case drop
    case mediumWaterLevel
    case highWaterLevel
    case magnifyingglassCircle
    case defaultPlantImage
    case heart
    case heartFill
    case humidity
    case trash
    case thermometerSun
    case thermometerSnow
    case thermometerLow
    case xmarkBin
    case arrowUpAndDown
    case arrowLeftAndRight
    case wind
    case exclamationmarkTriangle
    case logOut

    var uiImage: UIImage {
        let img: UIImage?
        if isSystemImage {
            img = UIImage(systemName: imageName)
        } else {
            img = UIImage(named: imageName)
        }
        if img == nil { assertionFailure() }
        return img ?? UIImage()
    }

    private var isSystemImage: Bool {
        switch self {
        case .homeScreenBackground,
            .homeIcon,
            .plantIcon,
            .searchIcon,
            .mediumWaterLevel,
            .highWaterLevel,
            .defaultPlantImage:
            return false
        case .checkmarkCircle,
            .checkmarkFill,
            .circle,
            .snooze,
            .close,
            .moreOptions,
            .clock,
            .unknown,
            .magnifyingglassCircle,
            .heart,
            .heartFill,
            .humidity,
            .trash,
            .thermometerSun,
            .thermometerSnow,
            .thermometerLow,
            .xmarkBin,
            .arrowUpAndDown,
            .arrowLeftAndRight,
            .wind,
            .exclamationmarkTriangle,
            .drop,
            .sunMax,
            .cloud,
            .cloudSun,
            .logOut:
            return true
        }
    }

    private var imageName: String {
        switch self {
        case .homeScreenBackground:
            return "calathea_homescreen"
        case .homeIcon:
            return "home"
        case .plantIcon:
            return "plant"
        case .searchIcon:
            return "search"
        case .checkmarkCircle:
            return "checkmark.circle"
        case .checkmarkFill:
            return "checkmark.circle.fill"
        case .circle:
            return "circle"
        case .snooze:
            return "moon.zzz"
        case .close:
            return "xmark.circle"
        case .moreOptions:
            return "ellipsis"
        case .clock:
            return "clock"
        case .unknown:
            return "questionmark"
        case .cloud:
            return "cloud"
        case .cloudSun:
            return "cloud.sun"
        case .sunMax:
            return "sun.max"
        case .drop:
            return "drop"
        case .mediumWaterLevel:
            return "medium_water_level"
        case .highWaterLevel:
            return "high_water_level"
        case .magnifyingglassCircle:
            return "magnifyingglass.circle"
        case .defaultPlantImage:
            return "default_plant_image"
        case .heart:
            return "heart"
        case .heartFill:
            return "heart.fill"
        case .humidity:
            return "humidity"
        case .trash:
            return "trash"
        case .thermometerSun:
            return "thermometer.sun"
        case .thermometerSnow:
            return "thermometer.snowflake"
        case .thermometerLow:
            return "thermometer.low"
        case .xmarkBin:
            return "xmark.bin"
        case .arrowUpAndDown:
            return "arrow.up.and.down"
        case .arrowLeftAndRight:
            return "arrow.left.and.right"
        case .wind:
            return "wind"
        case .exclamationmarkTriangle:
            return "exclamationmark.triangle"
        case .logOut:
            return "rectangle.portrait.and.arrow.right"
        }
    }
}
