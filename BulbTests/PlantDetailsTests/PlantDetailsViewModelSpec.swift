//
//  PlantDetailsViewModelSpec.swift
//  BulbTests
//
//  Created by Sabau Cristina on 20/12/2022.
//

import Quick
import Nimble
@testable import Bulb

final class PlantDetailsViewModelSpec: QuickSpec {
    override func spec() {
        var sut: PlantDetailsViewModel!
        var Plant: Plant!
        var plantServiceMock: PlantServiceMock!
        beforeEach {
            Plant = .stub(isFavourite: false)
            plantServiceMock = PlantServiceMock()
            sut = PlantDetailsViewModel(
                plant: Plant,
                plantService: plantServiceMock
            )
        }

        describe("content") {
            context("when view did load") {
                it("has 4 sections") {
                    let expectedNumberOfSections = 4
                    sut.viewDidLoad()
                    expect(sut.numberOfSections).to(equal(expectedNumberOfSections))
                }

                it("each section has expected number of items") {
                    sut.viewDidLoad()
                    let expectedNumberOfItemsSection0 = 2
                    let expectedNumberOfItemsSection1 = 4
                    let expectedNumberOfItemsSection2 = 3
                    let expectedNumberOfItemsSection3 = 3

                    expect(sut.numberOfItemsInSection(section: 0)).to(equal(expectedNumberOfItemsSection0))
                    expect(sut.numberOfItemsInSection(section: 1)).to(equal(expectedNumberOfItemsSection1))
                    expect(sut.numberOfItemsInSection(section: 2)).to(equal(expectedNumberOfItemsSection2))
                    expect(sut.numberOfItemsInSection(section: 3)).to(equal(expectedNumberOfItemsSection3))
                }

                it("each section should have expected header model") {
                    sut.viewDidLoad()
                    let expectedHeaderModel1 = HeaderView.Model.init(
                        title: "CARE"
                    )
                    let expectedHeaderModel2 = HeaderView.Model.init(
                        title: "LOCATION"
                    )
                    let expectedHeaderModel3 = HeaderView.Model.init(
                        title: "ABOUT"
                    )

                    expect(sut.headerModel(at: IndexPath(row: 0, section: 0))).to(beNil())
                    expect(sut.headerModel(at: IndexPath(row: 0, section: 1))).to(equal(expectedHeaderModel1))
                    expect(sut.headerModel(at: IndexPath(row: 0, section: 2))).to(equal(expectedHeaderModel2))
                    expect(sut.headerModel(at: IndexPath(row: 0, section: 3))).to(equal(expectedHeaderModel3))
                }
            }
        }

        describe("plant favourite button tapped") {
            it("calls service update function") {
                var plantToUpdate: Plant?
                plantServiceMock.updateIsFavouriteStub = { plant, _ in
                    plantToUpdate = plant
                }

                sut.updateIsFavourite()

                expect(plantToUpdate) == plant
            }
            context("when update completes successfully") {
                it("reloads") {
                    //given
                    plantServiceMock.updateIsFavouriteStub = { plant, completion in
                        completion(.success(.stub()))
                    }
                    var action: PlantDetailsViewModel.Action?
                    sut.onAction = { action = $0 }

                    //when
                    sut.updateIsFavourite()

                    //then
                    expect(action) == .reload
                }
            }

            context("when fails") {
                it("handles error") {
                    //given
                    let error = TestError()
                    plantServiceMock.updateIsFavouriteStub = { plant, completion in
                        completion(.failure(error))
                    }

                    var action: PlantDetailsViewModel.Action?
                    sut.onAction = { action = $0 }

                    //when
                    sut.updateIsFavourite()

                    //then
                    expect(action) == .handleError(error as NSError)
                }
            }
        }
    }
}
