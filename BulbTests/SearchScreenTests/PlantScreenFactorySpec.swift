//
//  PlantScreenFactorySpec.swift
//  BulbTests
//
//  Created by Sabau Cristina on 09/11/2022.
//

import UIKit
import Quick
import Nimble
@testable import Bulb

final class PlantScreenFactorySpec: QuickSpec {
    override func spec() {
        var plant: Plant!
        var sut: PlantScreenFactory!

        beforeEach {
            sut = PlantScreenFactory()
            plant = .stub()
        }

        describe("making") {
            context("plant template screen") {
                it("should create a PlantDetailsViewController") {
                    let controller = sut.makeShowPlantDetails(plant: plant)

                    expect(controller).to(beAKindOf(PlantDetailsViewController.self))
                }
            }
        }
    }
}
