//
//  SegmentedControlCell + Model.swift
//  Bulb
//
//  Created by Sabau Cristina on 28/10/2022.
//

import Foundation

extension SegmentedControlCell {
    struct Model: Equatable {
        static func == (
            lhs: SegmentedControlCell.Model,
            rhs: SegmentedControlCell.Model
        ) -> Bool {
            lhs.availableCategories == rhs.availableCategories &&
            lhs.selectedCategoryIndex == rhs.selectedCategoryIndex
        }

        let availableCategories: [String]
        var selectedCategoryIndex: Int?
        var onSegmentedControlHasChanged: (Int) -> Void
    }
}
