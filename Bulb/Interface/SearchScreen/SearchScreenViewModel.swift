//
//  SearchScreenViewModel.swift
//  Bulb
//
//  Created by Sabau Cristina on 21/10/2022.
//

import Foundation

final class SearchScreenViewModel {
    private let plantService: PlantServiceProtocol
    private let screenFactory: PlantScreenFactoryProtocol
    private let router: RouterProtocol
    private var plants = [Plant]()
    private var cellModels = [CellModel]()
    private var selectedCategory: PlantCategory = .all
    private var searchText: String = ""

    enum CellModel: Equatable {
        case segmentedControl(SegmentedControlCell.Model)
        case plantItem(PlantViewCell.Model)
        case simpleBanner(SimpleBannerCell.Model)

        var onTap: (() -> Void)? {
            switch self {
            case .segmentedControl, .simpleBanner:
                return nil
            case let .plantItem(model):
                return model.onTap
            }
        }
    }

    enum Action: Equatable {
        case reload
        case handleError(NSError)
    }
    var onAction: ((Action) -> Void)?

    init(
        plantService: PlantServiceProtocol,
        screenFactory: PlantScreenFactoryProtocol,
        router: RouterProtocol
    ) {
        self.plantService = plantService
        self.screenFactory = screenFactory
        self.router = router
    }

    convenience init() {
        self.init(
            plantService: PlantService(),
            screenFactory: PlantScreenFactory(),
            router: Router()
        )
    }

    func willAppear() {
        search()
    }

    func setSearchText(searchTerm: String) {
        searchText = searchTerm
        search()
    }
}

// MARK: - TableView DataSource

extension SearchScreenViewModel {
    func numbersOfRowsInSection() -> Int {
        cellModels.count
    }

    func cellModel(for index: IndexPath) -> CellModel {
        cellModels[index.row]
    }

    func onTapCell(for index: IndexPath) {
        cellModels[index.row].onTap?()
    }
}

// MARK: Cell Makers

private extension SearchScreenViewModel {
    func updateCellModels(with plants: [Plant]) {
        cellModels = [
            .segmentedControl(makeSegmentedControlModel())
        ]
        if plants.isEmpty {
            cellModels.append(.simpleBanner(makeNoResultsBanner()))
        } else {
            cellModels.append(
                contentsOf: plants.map { .plantItem(makePlantModel(plant: $0)) }
            )
        }
    }

    func makePlantModel(plant: Plant) -> PlantViewCell.Model {
        PlantViewCell.Model(
            plantName: plant.name,
            scientificName: plant.scientificName,
            lightImage: plant.lightLevel.image,
            waterImage: plant.waterLevel.image,
            maintenanceLevel: plant.maintenanceLevel,
            imageURL: plant.imageURL,
            onTap: { [weak self] in
                guard let self = self else { return }

                let screen = self.screenFactory.makeShowPlantDetails(
                    plant: plant
                )
                screen.hidesBottomBarWhenPushed = true
                self.router.push(screen)
            }
        )
    }

    func makeSegmentedControlModel() -> SegmentedControlCell.Model {
        SegmentedControlCell.Model(
            availableCategories: PlantCategory.allCases.map { $0.name },
            selectedCategoryIndex: PlantCategory.allCases.firstIndex(of: selectedCategory),
            onSegmentedControlHasChanged: { [weak self] selectedSegmentIndex in
                guard let self = self else { return }
                self.selectedCategory = PlantCategory.allCases[selectedSegmentIndex]
                self.search()
            }
        )
    }

    func makeNoResultsBanner() -> SimpleBannerCell.Model {
        SimpleBannerCell.Model(
            title: "No results",
            icon: Image.magnifyingglassCircle
        )
    }
}

// MARK: - API requests

private extension SearchScreenViewModel {
    func search() {
        search(searchTerm: searchText, selectedCategory: selectedCategory)
    }

    func search(
        searchTerm: String,
        selectedCategory: PlantCategory
    ) {
        plantService.search(
            searchKey: searchTerm,
            category: selectedCategory
        ) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case let .success(plants):
                self.plants = plants.sorted(by: { $0.name < $1.name })
                self.updateCellModels(with: self.plants)
                self.onAction?(.reload)
            case let .failure(error):
                self.plants = []
                self.updateCellModels(with: self.plants)
                self.onAction?(.handleError(error as NSError))
            }
        }
    }
}
