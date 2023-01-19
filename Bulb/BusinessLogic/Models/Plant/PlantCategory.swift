//
//  PlantCategory.swift
//  Bulb
//
//  Created by Sabau Cristina on 23/09/2022.
//

import Foundation

enum PlantCategory: String, CaseIterable {
    case all
    case favourites
    case badCondition
    case goodCondition

    var name: String {
        switch self {
        case .all:
            return "All"
        case .favourites:
            return "Favourites"
        case .badCondition:
            return "I'm dying"
        case .goodCondition:
            return "Feeling good"
        }
    }

    var value: String {
        switch self {

        case .all:
            return "all"
        case .favourites:
            return "favourites"
        case .badCondition:
            return "bad"
        case .goodCondition:
            return "good"
        }
    }
}
