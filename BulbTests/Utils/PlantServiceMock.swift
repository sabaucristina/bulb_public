//
//  PlantServiceMock.swift
//  BulbTests
//
//  Created by Sabau Cristina on 02/11/2022.
//

import Foundation
@testable import Bulb

final class PlantServiceMock: PlantServiceProtocol {
    var updateIsFavouriteStub: ((Plant, @escaping UpdateDataCompletion) -> Void)!
    func updateIsFavourite(
        plant: Bulb.Plant,
        completion: @escaping UpdateDataCompletion
    ) {
        updateIsFavouriteStub(plant, completion)
    }

    var getPlantsStub: ((FetchDataCompletion) -> Void)!
    func getPlants(completion: @escaping FetchDataCompletion) {
        getPlantsStub(completion)
    }

    var searchStub: ((String, PlantCategory, FetchDataCompletion) -> Void)!
    func search(searchKey: String, category: Bulb.PlantCategory, completion: @escaping FetchDataCompletion) {
        searchStub(searchKey, category, completion)
    }
}
