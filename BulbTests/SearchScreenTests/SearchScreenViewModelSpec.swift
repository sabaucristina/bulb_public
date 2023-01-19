//
//  SearchScreenViewModel.swift
//  BulbTests
//
//  Created by Sabau Cristina on 02/11/2022.
//

import Quick
import Nimble
@testable import Bulb

final class SearchScreeenViewModelSpec: QuickSpec {
    override func spec() {
        var sut: SearchScreenViewModel!
        var plantServiceMock: PlantServiceMock!
        var screenFactoryMock: PlantScreenFactoryMock!
        var routerMock: RouterMock!
        var plants: [Plant]!
        
        beforeEach {
            plantServiceMock = PlantServiceMock()
            screenFactoryMock = PlantScreenFactoryMock()
            routerMock = RouterMock()
            plants = Array.init(repeating: .stub(), count: 3)
            sut = SearchScreenViewModel(
                plantService: plantServiceMock,
                screenFactory: screenFactoryMock,
                router: routerMock
            )
        }
        
        func setupWhenSearchSucceedsWithoutData() {
            plantServiceMock.searchStub = { _, _, completion in
                completion(.success([]))
            }
        }
        
        func setupWhenSearchSucceedsWithData() {
            plantServiceMock.searchStub = { selectedCategory, searchText, completion in
                completion(.success(plants))
            }
        }
        
        func setupWhenSearchFails() {
            plantServiceMock.searchStub = { selectedCategory, searchText, completion in
                let error = TestError()
                completion(.failure(error))
            }
        }
        
        describe("content") {
            context("when search succeds with no data") {
                beforeEach {
                    setupWhenSearchSucceedsWithoutData()
                }
                it("has segmentedControl as first cell and no results banner") {
                    //given
                    let expectedSegmentedControlCell: SearchScreenViewModel.CellModel =
                        .segmentedControl(
                            SegmentedControlCell.Model(
                                availableCategories: PlantCategory.allCases.map { $0.name },
                                selectedCategoryIndex: 0,
                                onSegmentedControlHasChanged:{ _ in }
                            )
                        )
                    
                    let expectedBannerCellModel: SearchScreenViewModel.CellModel =
                        .simpleBanner(
                            SimpleBannerCell.Model(
                                title: "No results",
                                icon: Image.magnifyingglassCircle
                            )
                        )
                    
                    //when
                    sut.willAppear()
                    let firstCell = sut.cellModel(for: IndexPath(row: 0, section: 0))
                    let simpleBanner = sut.cellModel(for: IndexPath(row: 1, section: 0))
                    
                    //then
                    expect(sut.numbersOfRowsInSection()) == 2
                    expect(firstCell).to(equal(expectedSegmentedControlCell))
                    expect(simpleBanner).to(equal(expectedBannerCellModel))
                }
            }
            context("when search fails") {
                beforeEach {
                    setupWhenSearchFails()
                }
                it("has segmentedControl as first cell and no results banner") {
                    //given
                    let expectedSegmentedControlCell: SearchScreenViewModel.CellModel =
                        .segmentedControl(
                            SegmentedControlCell.Model(
                                availableCategories: PlantCategory.allCases.map { $0.name },
                                selectedCategoryIndex: 0,
                                onSegmentedControlHasChanged:{ _ in }
                            )
                        )
                    
                    let expectedBannerCellModel: SearchScreenViewModel.CellModel =
                        .simpleBanner(
                            SimpleBannerCell.Model(
                                title: "No results",
                                icon: Image.magnifyingglassCircle
                            )
                        )
                    
                    //when
                    sut.willAppear()
                    let firstCell = sut.cellModel(for: IndexPath(row: 0, section: 0))
                    let simpleBanner = sut.cellModel(for: IndexPath(row: 1, section: 0))
                    
                    //then
                    expect(sut.numbersOfRowsInSection()) == 2
                    expect(firstCell).to(equal(expectedSegmentedControlCell))
                    expect(simpleBanner).to(equal(expectedBannerCellModel))
                }
            }
            
            context("when search succeeds with data") {
                beforeEach {
                    setupWhenSearchSucceedsWithData()
                }
                it("should have expectedNumberOfRows rows") {
                    //when
                    sut.willAppear()
                    let expectedNumberOfRows = plants.count + 1
                    
                    //then
                    expect(sut.numbersOfRowsInSection()) == expectedNumberOfRows
                }
                
                it("has a segmented control cell model and X plant templates cell models") {
                    sut.willAppear()
                    let expectedSegmentedControlCell: SearchScreenViewModel.CellModel =
                        .segmentedControl(
                            SegmentedControlCell.Model(
                                availableCategories: PlantCategory.allCases.map { $0.name },
                                selectedCategoryIndex: 0,
                                onSegmentedControlHasChanged:{ _ in }
                            )
                        )
                    let expectedPlants: [SearchScreenViewModel.CellModel] = plants.map { plant in
                            .plantItem(
                                PlantViewCell.Model(
                                    plantName: plant.name,
                                    scientificName: plant.scientificName,
                                    lightImage: plant.lightLevel.image,
                                    waterImage: plant.waterLevel.image,
                                    maintenanceLevel: plant.maintenanceLevel,
                                    imageURL: plant.imageURL,
                                    onTap: { }
                                )
                            )
                        
                    }
                    
                    let firstCell = sut.cellModel(for: IndexPath(row: 0, section: 0))
                    let plantCells = (1..<sut.numbersOfRowsInSection()).map { sut.cellModel(for: IndexPath(row: $0, section: 0)) }
                    
                    //then
                    expect(firstCell).to(equal(expectedSegmentedControlCell))
                    expect(plantCells).to(equal(expectedPlants))
                }
            }
        }
        describe("perform search") {
            context("when search fails") {
                beforeEach {
                    setupWhenSearchFails()
                }
                it("has onAction handleError") {
                    //given
                    let error = TestError()
                    var action: SearchScreenViewModel.Action?
                    sut.onAction = { incomingAction in
                        action = incomingAction
                    }
                    
                    //when
                    sut.willAppear()
                    
                    //then
                    expect(action).to(equal(.handleError(error as NSError)))
                }
            }
        }
        describe("show plant template details screen") {
            context("when onTap on a plant cell") {
                beforeEach {
                    setupWhenSearchSucceedsWithData()
                }
                it("should present the view controller") {
                    let controller = UIViewController()
                    screenFactoryMock.makeShowPlantDetailsStub = { plant in
                        return controller
                    }
                    
                    var presentedScreen: UIViewController?
                    routerMock.pushStub = { screen in
                        presentedScreen = screen
                    }
                    sut.setSearchText(searchTerm: "")
                    sut.onTapCell(for: IndexPath(row: 1, section: 0))
                    
                    expect(presentedScreen) === controller
                }
            }
        }
    }
}
