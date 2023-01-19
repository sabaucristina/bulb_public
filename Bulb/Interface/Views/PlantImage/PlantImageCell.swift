//
//  PlantImageCell.swift
//  Bulb
//
//  Created by Sabau Cristina on 11/11/2022.
//

import UIKit

final class PlantImageCell: UICollectionViewCell {
    private enum Constants {
        static let mainStackSize: CGFloat = 220
        static let mainStackSpacing: CGFloat = 10
        static let tagStackSize: CGFloat = 60
        static let mainStackMargins = UIEdgeInsets(
            top: 10,
            left: 10,
            bottom: 10,
            right: 10
        )
        static let tagStackMargins = UIEdgeInsets(
            top: 5,
            left: 5,
            bottom: 5,
            right: 5
        )
        static let fontSizeValue: CGFloat = 10
        static let fontSizeTitle: CGFloat = 14
        static let maintenanceTagTitle = "Care"
    }
    static let identifierName = String(describing: type(of: PlantImageCell.self))
    private lazy var plantImage = makePlantImageView()
    private lazy var tagsStack = makeTagsStack()
    private lazy var waterTagStack = makeWaterTagStackView()
    private lazy var waterTagLabel = makeWaterTagLabel()
    private lazy var waterTagIcon = makeWaterTagIcon()
    private lazy var lightTagStack = makeLightTagStackView()
    private lazy var lightTagLabel = makeLightTagLabel()
    private lazy var lightTagIcon = makeLightTagIcon()
    private lazy var maintenanceStack = makeMaintenanceTagStackView()
    private lazy var maintenanceTitle = makeMaintenanceTagTitle()
    private lazy var maintenanceValue = makeMaintenanceTagValue()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(model: Model) {
        plantImage.loadPlantImage(imageURL: model.imageURL)
        waterTagIcon.image = model.waterImage.uiImage
        lightTagIcon.image = model.lightImage.uiImage
        waterTagLabel.attributedText = NSAttributedString(
            string: model.waterLevel,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: Constants.fontSizeValue),
                .foregroundColor: UIColor.black
            ]
        )
        lightTagLabel.attributedText = NSAttributedString(
            string: model.lightLevel,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: Constants.fontSizeValue),
                .foregroundColor: UIColor.black
            ]
        )
        maintenanceValue.attributedText = NSAttributedString(
            string: model.maintenanceLevel,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: Constants.fontSizeValue),
                .foregroundColor: UIColor.black
            ]
        )
    }

    func setupUI() {
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        contentView.addSubview(plantImage)
        contentView.addSubview(tagsStack)
        tagsStack.addArrangedSubview(waterTagStack)
        tagsStack.addArrangedSubview(lightTagStack)
        tagsStack.addArrangedSubview(maintenanceStack)
        waterTagStack.addArrangedSubview(waterTagIcon)
        waterTagStack.addArrangedSubview(waterTagLabel)
        lightTagStack.addArrangedSubview(lightTagIcon)
        lightTagStack.addArrangedSubview(lightTagLabel)
        maintenanceStack.addArrangedSubview(maintenanceTitle)
        maintenanceStack.addArrangedSubview(maintenanceValue)
    }

    func setupConstraints() {
        plantImage.pinToSuperviewEdges()

        NSLayoutConstraint.activate([
            tagsStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -VerticalSpacing.pt16),
            tagsStack.leftAnchor.constraint(equalTo: plantImage.leftAnchor, constant: HorizontalSpacing.pt16),
            tagsStack.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.mainStackSize),
            waterTagStack.heightAnchor.constraint(equalToConstant: Constants.tagStackSize),
            waterTagStack.widthAnchor.constraint(equalToConstant: Constants.tagStackSize),
            lightTagStack.heightAnchor.constraint(equalToConstant: Constants.tagStackSize),
            lightTagStack.widthAnchor.constraint(equalToConstant: Constants.tagStackSize),
            maintenanceStack.heightAnchor.constraint(equalToConstant: Constants.tagStackSize),
            maintenanceStack.widthAnchor.constraint(equalToConstant: Constants.tagStackSize),
            waterTagIcon.heightAnchor.constraint(equalToConstant: ImageSize.iconSize),
            waterTagIcon.widthAnchor.constraint(equalToConstant: ImageSize.iconSize),
            lightTagIcon.heightAnchor.constraint(equalToConstant: ImageSize.iconSize),
            lightTagIcon.widthAnchor.constraint(equalToConstant: ImageSize.iconSize)
        ])
    }

    func makePlantImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        return imageView
    }

    func makeTagsStack() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = Constants.mainStackSpacing
        stackView.layoutMargins = Constants.mainStackMargins
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        stackView.layer.cornerRadius = Constants.tagStackSize / 2

        return stackView
    }

    func makeWaterTagStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 0
        stack.layoutMargins = Constants.tagStackMargins
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = Color.matteGreen
        stack.layer.cornerRadius = Constants.tagStackSize / 2

        return stack
    }

    func makeWaterTagLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }

    func makeWaterTagIcon() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Image.drop.uiImage
        imageView.contentMode = .center

        return imageView
    }

    func makeLightTagStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 0
        stack.layoutMargins = Constants.tagStackMargins
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = Color.matteGreen
        stack.layer.cornerRadius = Constants.tagStackSize / 2

        return stack
    }

    func makeLightTagLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }

    func makeLightTagIcon() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Image.drop.uiImage
        imageView.contentMode = .center

        return imageView
    }

    func makeMaintenanceTagStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 0
        stack.layoutMargins = Constants.tagStackMargins
        stack.isLayoutMarginsRelativeArrangement = true
        stack.backgroundColor = Color.matteGreen
        stack.layer.cornerRadius = Constants.tagStackSize / 2

        return stack
    }

    func makeMaintenanceTagTitle() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.attributedText = NSAttributedString(
            string: Constants.maintenanceTagTitle,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: Constants.fontSizeTitle),
                .foregroundColor: UIColor.tintColor
            ]
        )
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }

    func makeMaintenanceTagValue() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }
}
