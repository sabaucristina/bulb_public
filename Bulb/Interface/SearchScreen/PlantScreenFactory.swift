//
//  PlantScreenFactory.swift
//  Bulb
//
//  Created by Sabau Cristina on 09/11/2022.
//

import UIKit

protocol PlantScreenFactoryProtocol: AnyObject {
    func makeShowPlantDetails(
        plant: Plant
    ) -> UIViewController
}

final class PlantScreenFactory: PlantScreenFactoryProtocol {
    func makeShowPlantDetails(
        plant: Plant
    ) -> UIViewController {
        let plantViewModel = PlantDetailsViewModel(
            plant: plant
        )
        return PlantDetailsViewController(
            viewModel: plantViewModel
        )
    }
}
