//
//  AddPlantButtonCell+Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 16/11/2022.
//

import Foundation

extension AddPlantButtonCell {
    struct Model {
        let title: String
        let subtitle: String
        let accessoryButtonIcon: Image
        let onFavouriteButtonTap: () -> Void
    }
}
