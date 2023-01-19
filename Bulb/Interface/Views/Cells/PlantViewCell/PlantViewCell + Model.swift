//
//  PlantViewCell + Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 26/10/2022.
//

import Foundation
import UIKit

extension PlantViewCell {
    struct  Model: Equatable {
        static func == (
            lhs: PlantViewCell.Model,
            rhs: PlantViewCell.Model
        ) -> Bool {
            lhs.plantName == rhs.plantName &&
            lhs.scientificName == rhs.scientificName &&
            lhs.lightImage == rhs.lightImage &&
            lhs.waterImage == rhs.waterImage &&
            lhs.maintenanceLevel == rhs.maintenanceLevel &&
            lhs.imageURL == rhs.imageURL
        }

        let plantName: String
        let scientificName: String
        let lightImage: Image
        let waterImage: Image
        let maintenanceLevel: String
        let imageURL: String
        let onTap: (() -> Void)?
    }
}
