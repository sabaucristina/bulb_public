//
//  PlantDetailsViewModel.swift
//  Bulb
//
//  Created by Sabau Cristina on 09/11/2022.
//

import UIKit

final class PlantDetailsViewModel {
    private var sections: [Section]!
    private let plantService: PlantServiceProtocol

    enum Section {
        case overview([CellModel])
        case care([CellModel])
        case location([CellModel])
        case about([CellModel])

        var cellModels: [CellModel] {
            switch self {
            case .overview(let cellmodels):
                return cellmodels
            case .care(let cellModels):
                return cellModels
            case .location(let cellModels):
                return cellModels
            case .about(let cellModels):
                return cellModels
            }
        }

        var headerTitle: String? {
            switch self {
            case .overview:
                return nil
            case .care:
                return "CARE"
            case .location:
                return "LOCATION"
            case .about:
                return "ABOUT"
            }
        }
    }

    enum CellModel {
        case plantImage(PlantImageCell.Model)
        case addPlantButtons(AddPlantButtonCell.Model)
        case instructions(InstructionsCell.Model)
    }

    enum Action: Equatable {
        case handleError(NSError)
        case reload
    }

    var onAction: ((Action) -> Void)?
    var plant: Plant

    init(
        plant: Plant,
        plantService: PlantServiceProtocol
    ) {
        self.plant = plant
        self.plantService = plantService
    }

    convenience init(
        plant: Plant
    ) {
        self.init(
            plant: plant,
            plantService: PlantService()
        )
    }
}
// MARK: Data Source

extension PlantDetailsViewModel {
    func numberOfSections() -> Int {
        sections.count
    }
    func numberOfItemsInSection(section: Int) -> Int {
        sections[section].cellModels.count
    }

    func section(at index: Int) -> Section {
        sections[index]
    }

    func cellModel(at index: IndexPath) -> CellModel {
        sections[index.section].cellModels[index.row]
    }

    func headerModel(at index: IndexPath) -> HeaderView.Model? {
        let title = sections[index.section].headerTitle
        return makeHeader(with: title)
    }

    func viewDidLoad() {
        updateSections()
    }
}

// MARK: Update Sections

private extension PlantDetailsViewModel {
    func updateSections() {
        let cellModelsOverview: [CellModel] = [
            .plantImage(makePlantImageModel()),
            .addPlantButtons(makeAddPlantButtonsModel())
        ]
        let cellModelsCare: [CellModel] = [
            .instructions(makeWaterInstructionsModel()),
            .instructions(makeFertilizerInstructionsModel()),
            .instructions(makeHumidityInstructionsModel()),
            .instructions(makeCleanInstructionsModel())
        ]
        let cellModelsLocation: [CellModel] = [
            .instructions(makeLightInstructionsModel()),
            .instructions(makeIdealTemparatureModel()),
            .instructions(makeHardinessZoneModel())
        ]
        let cellModelsAbout: [CellModel] = [
            .instructions(makeSoilModel()),
            .instructions(makeDimensionsModel()),
            .instructions(makeOtherModel())
        ]
        sections = [
            .overview(cellModelsOverview),
            .care(cellModelsCare),
            .location(cellModelsLocation),
            .about(cellModelsAbout)
        ]
    }
}

// MARK: API calls

extension PlantDetailsViewModel {
    func updateIsFavourite() {
        plantService.updateIsFavourite(
            plant: plant
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let updatedPlant):
                self.plant = updatedPlant
                self.updateSections()
                self.onAction?(.reload)
            case .failure(let error):
                self.onAction?(
                    .handleError(error as NSError)
                )
            }
        }
    }
}

// MARK: Cell makers

private extension PlantDetailsViewModel {
    func makeHeader(with title: String?) -> HeaderView.Model? {
        guard let title = title else { return nil }
        return HeaderView.Model(title: title)
    }

    func makePlantImageModel() -> PlantImageCell.Model {
        return PlantImageCell.Model(
            imageURL: plant.imageURL,
            waterImage: plant.waterLevel.image,
            lightImage: plant.lightLevel.image,
            waterLevel: plant.waterLevel.rawValue,
            lightLevel: plant.lightLevel.rawValue,
            maintenanceLevel: plant.maintenanceLevel
        )
    }

    func makeAddPlantButtonsModel() -> AddPlantButtonCell.Model {
        return AddPlantButtonCell.Model(
            title: plant.name,
            subtitle: plant.scientificName,
            accessoryButtonIcon: plant.isFavourite ? Image.heartFill : Image.heart,
            onFavouriteButtonTap: { [weak self] in
                self?.updateIsFavourite()
            }
        )
    }

    func makeWaterInstructionsModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Water",
            firstAccessoryText: plant.wateringInterval.description,
            secondAccessoryIcon: plant.waterLevel.image,
            firstInstructionText: "Water every \(plant.wateringInterval) days",
            secondInstructionText: plant.waterLevel.instruction,
            hasASingleInstruction: false,
            hasFirstAccessoryText: true
        )
    }

    func makeFertilizerInstructionsModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Fertilizer",
            firstAccessoryText: plant.fertilizingInterval.description,
            secondAccessoryIcon: Image.close,
            firstInstructionText: "Fertilize every \(plant.fertilizingInterval) days",
            secondInstructionText: "Skip if the plant is not doing well",
            hasASingleInstruction: false,
            hasFirstAccessoryText: true
        )
    }

    func makeHumidityInstructionsModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Humidity",
            secondAccessoryIcon: Image.humidity,
            secondInstructionText: plant.humidityLevel.instruction,
            hasASingleInstruction: true,
            hasFirstAccessoryText: true
        )
    }

    func makeCleanInstructionsModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Clean",
            secondAccessoryIcon: Image.trash,
            secondInstructionText: plant.cleanLevel.instruction,
            hasASingleInstruction: true,
            hasFirstAccessoryText: true
        )
    }

    func makeLightInstructionsModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Light",
            secondAccessoryIcon: plant.lightLevel.image,
            secondInstructionText: plant.lightLevel.instruction,
            hasASingleInstruction: true,
            hasFirstAccessoryText: true
        )
    }

    func makeIdealTemparatureModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Ideal temparature",
            firstAccessoryIcon: Image.thermometerSnow,
            secondAccessoryIcon: Image.thermometerSun,
            firstInstructionText: String(plant.lightLevel.minimumIdealTemparature) + "°C minimum",
            secondInstructionText: String(plant.lightLevel.maximumIdealTemparature) + "°C maximum",
            hasASingleInstruction: false,
            hasFirstAccessoryText: false
        )
    }

    func makeHardinessZoneModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Hardiness zone",
            secondAccessoryIcon: Image.thermometerLow,
            secondInstructionText: String(plant.lightLevel.hardinessZone) + "°C - lowest temp. to survive",
            hasASingleInstruction: true,
            hasFirstAccessoryText: false
        )
    }

    func makeSoilModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Soil & Repotting",
            secondAccessoryIcon: Image.xmarkBin,
            secondInstructionText: "Every year",
            hasASingleInstruction: true,
            hasFirstAccessoryText: false
        )
    }

    func makeDimensionsModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Dimensions",
            firstAccessoryIcon: Image.arrowUpAndDown,
            secondAccessoryIcon: Image.arrowLeftAndRight,
            firstInstructionText: "Height " + plant.plantHeight,
            secondInstructionText: "Width " + plant.plantWidth,
            hasASingleInstruction: false,
            hasFirstAccessoryText: false
        )
    }

    func makeOtherModel() -> InstructionsCell.Model {
        return InstructionsCell.Model(
            title: "Other",
            firstAccessoryIcon: Image.wind,
            secondAccessoryIcon: Image.exclamationmarkTriangle,
            firstInstructionText: "Sensitive to draft",
            secondInstructionText: "Toxic for animals",
            hasASingleInstruction: false,
            hasFirstAccessoryText: false
        )
    }
}
