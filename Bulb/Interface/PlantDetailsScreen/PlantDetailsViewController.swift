//
//  PlantDetailsViewController.swift
//  Bulb
//
//  Created by Sabau Cristina on 09/11/2022.
//
import UIKit

final class PlantDetailsViewController: UIViewController, UICollectionViewDelegate {
    private let viewModel: PlantDetailsViewModel
    private lazy var collectionView = makeCollectionView()

    init(
        viewModel: PlantDetailsViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        viewModel.onAction = { [weak self] action in
            switch action {
            case .handleError(let error):
                self?.view.displayError(error: error)
            case .reload:
                self?.collectionView.reloadData()
            }
        }

        viewModel.viewDidLoad()
        collectionView.reloadData()
    }

    func setupNavigationBar() {
        title = "\(viewModel.plant.name) (\(viewModel.plant.scientificName))"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
    }

    func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: generateLayout()
        )
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            PlantImageCell.self,
            forCellWithReuseIdentifier: PlantImageCell.identifierName
        )
        collectionView.register(
            AddPlantButtonCell.self,
            forCellWithReuseIdentifier: AddPlantButtonCell.identifierName
        )
        collectionView.register(
            InstructionsCell.self,
            forCellWithReuseIdentifier: InstructionsCell.identifierName
        )
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.identifierName
        )
        return collectionView
    }

    func generateLayout() -> UICollectionViewLayout {
        let layout =
        UICollectionViewCompositionalLayout {[weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            let section = self.viewModel.section(at: sectionIndex)

            switch section {
            case .overview:
                return self.generateOverviewSection()
            case .care:
                return self.generateInstructionsSection()
            case .location:
                return self.generateInstructionsSection()
            case .about:
                return self.generateInstructionsSection()
            }
        }

        return layout
    }

    func generateOverviewSection() -> NSCollectionLayoutSection {
        let fullPhotoItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/3)
        )
        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: fullPhotoItemSize)
        let buttonsPairItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(2/9)
        )
        let buttonsPairItem = NSCollectionLayoutItem(layoutSize: buttonsPairItemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(8/9)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [
                fullPhotoItem,
                buttonsPairItem
            ]
        )

        let section = NSCollectionLayoutSection(group: group)

        return section
    }

    func generateInstructionsSection() -> NSCollectionLayoutSection {
        let instructionsItemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(201)
        )
        let instructionsItem = NSCollectionLayoutItem(layoutSize: instructionsItemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .absolute(201)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: instructionsItem,
            count: 1
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 5,
            bottom: 5,
            trailing: 5
        )

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(55)
        )

        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }
}

extension PlantDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections()
    }
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        viewModel.numberOfItemsInSection(section: section)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: HeaderView.identifierName,
                for: indexPath
            )
            let model = viewModel.headerModel(at: indexPath)

            if let model = model {
                (header as? HeaderView)?.update(with: model)
            }

            return header
        default:
            return UICollectionReusableView()
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cellModel = viewModel.cellModel(at: indexPath)

        switch cellModel {
        case .plantImage(let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PlantImageCell.identifierName,
                for: indexPath
            )
            (cell as? PlantImageCell)?.update(model: model)
            return cell
        case .addPlantButtons(let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddPlantButtonCell.identifierName,
                for: indexPath
            )
            (cell as? AddPlantButtonCell)?.update(model: model)
            return cell
        case .instructions(let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: InstructionsCell.identifierName,
                for: indexPath
            )
            (cell as? InstructionsCell)?.update(model: model)
            return cell
        }
    }
}
