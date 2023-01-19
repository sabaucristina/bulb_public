//
//  PlantViewCell.swift
//  Bulb
//
//  Created by Sabau Cristina on 25/10/2022.
//

import UIKit

final class PlantViewCell: UITableViewCell {
    private enum Constants {
        static let maintenanceHeight: CGFloat = 24
        static let maintenanceWidth: CGFloat = 60
        static let maintenanceLabelFontSize: CGFloat = 11
        static let maintenanceLabelMargins: CGFloat = 6
    }
    static let identifierName = String(describing: type(of: PlantViewCell.self))
    private lazy var containerView = UIView()
    private lazy var textStackView = UIStackView()
    private lazy var plantImage = makePlantImage()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var accessoryStackView = UIStackView()
    private lazy var lightLevelImageView = makeLightLevelImageView()
    private lazy var waterLevelImageView = makeWaterLevelImageView()
    private lazy var maintenanceLabel = makeMaintenanceLabel()
    private lazy var maintenanceContainer = makeMaintenanceContainer()
    private var model: Model?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: Model) {
        self.model = model

        titleLabel.text = model.plantName
        subtitleLabel.text = model.scientificName
        plantImage.loadPlantIcon(imageURL: model.imageURL)
        lightLevelImageView.image = model.lightImage.uiImage.withTintColor(Color.darkMatteGreen)
        waterLevelImageView.image = model.waterImage.uiImage.withTintColor(Color.darkMatteGreen)

        maintenanceLabel.attributedText = NSAttributedString(
            string: model.maintenanceLevel.capitalized,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: Constants.maintenanceLabelFontSize),
                .foregroundColor: UIColor.black
            ]
        )
    }
}

private extension PlantViewCell {
    func setupUI() {
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        accessoryStackView.translatesAutoresizingMaskIntoConstraints = false

        textStackView.axis = .vertical
        accessoryStackView.axis = .horizontal
        accessoryStackView.spacing = HorizontalSpacing.pt8
    }

    func setupHierarchy() {
        contentView.addSubview(containerView)

        containerView.addSubview(plantImage)
        containerView.addSubview(textStackView)
        containerView.addSubview(accessoryStackView)

        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)

        accessoryStackView.addArrangedSubview(maintenanceContainer)
        accessoryStackView.addArrangedSubview(lightLevelImageView)
        accessoryStackView.addArrangedSubview(waterLevelImageView)

        maintenanceContainer.addSubview(maintenanceLabel)
    }

    func setupConstraints() {
        containerView.pinToSuperviewEdges()

        plantImage.pinToSuperviewEdges(
            edges: [
                .top(VerticalSpacing.pt10),
                .bottom(-VerticalSpacing.pt10),
                .left(HorizontalSpacing.pt16)
            ]
        )
        accessoryStackView.pinToSuperviewEdges(
            edges: [.right(-HorizontalSpacing.pt16)])

        textStackView
            .leftAnchor
            .constraint(
                equalTo: plantImage.rightAnchor, constant: HorizontalSpacing.pt16
            ).isActive = true
        textStackView
            .centerYAnchor
            .constraint(equalTo: plantImage.centerYAnchor).isActive = true
        textStackView
            .rightAnchor
            .constraint(
                lessThanOrEqualTo: accessoryStackView.leftAnchor,
                constant: -HorizontalSpacing.pt8
            ).isActive = true

        maintenanceLabel.pinToSuperviewEdges(
            edges: [
                .top(Constants.maintenanceLabelMargins),
                .bottom(-Constants.maintenanceLabelMargins),
                .left(Constants.maintenanceLabelMargins),
                .right(-Constants.maintenanceLabelMargins)
            ]
        )

        NSLayoutConstraint.activate([
            plantImage.heightAnchor.constraint(equalToConstant: ImageSize.imageSize),
            plantImage.widthAnchor.constraint(equalTo: plantImage.heightAnchor),
            maintenanceContainer.heightAnchor.constraint(equalToConstant: Constants.maintenanceHeight),
            accessoryStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            waterLevelImageView.heightAnchor.constraint(equalToConstant: ImageSize.iconSize),
            waterLevelImageView.widthAnchor.constraint(equalTo: waterLevelImageView.heightAnchor),
            lightLevelImageView.heightAnchor.constraint(equalToConstant: ImageSize.iconSize),
            lightLevelImageView.widthAnchor.constraint(equalTo: lightLevelImageView.heightAnchor)
        ])
    }
}

private extension PlantViewCell {
    func makePlantImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = Color.matteGreen.cgColor
        imageView.layer.cornerRadius = ImageSize.imageSize / 2
        imageView.clipsToBounds = true

        return imageView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()

        return label
    }

    func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Color.matteGreen

        return label
    }

    func makeLightLevelImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Color.darkMatteGreen
        imageView.contentMode = .center

        return imageView
    }

    func makeWaterLevelImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Color.darkMatteGreen
        imageView.contentMode = .center

        return imageView
    }

    func makeMaintenanceLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }

    func makeMaintenanceContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = Color.matteGreen.withAlphaComponent(0.5)
        view.layer.cornerRadius = Constants.maintenanceHeight / 2

        return view
    }
}
