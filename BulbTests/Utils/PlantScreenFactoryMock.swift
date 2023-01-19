//
//  PlantScreenFactory.swift
//  BulbTests
//
//  Created by Sabau Cristina on 09/11/2022.
//
import UIKit
@testable import Bulb

final class PlantScreenFactoryMock: PlantScreenFactoryProtocol {
    var makeShowPlantDetailsStub: ((Plant) -> UIViewController)!
    func makeShowPlantDetails(
        plant: Plant
    ) -> UIViewController {
        makeShowPlantDetailsStub(plant)
    }
}
