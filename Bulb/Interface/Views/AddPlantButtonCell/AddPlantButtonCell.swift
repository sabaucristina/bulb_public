//
//  AddPlantButtonCell.swift
//  Bulb
//
//  Created by Sabau Cristina on 16/11/2022.
//

import UIKit

final class AddPlantButtonCell: UICollectionViewCell {
    private enum Constants {
        static let accesorySize: CGFloat = 50
        static let stackSpacing: CGFloat = 10
    }
    static let identifierName = String(describing: type(of: AddPlantButtonCell.self))
    private lazy var mainStack = makeMainStack()
    private lazy var titleStack = makeTitleStack()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var accessoryButton = makeAccessoryButton()
    private var model: Model?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(model: Model) {
        self.model = model

        titleLabel.attributedText = NSAttributedString(
            string: model.title,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 22),
                .foregroundColor: UIColor.black
            ]
        )

        subtitleLabel.attributedText = NSAttributedString(
            string: model.subtitle,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16),
                .foregroundColor: Color.matteGreen
            ]
        )

        accessoryButton.setImage(
            model.accessoryButtonIcon.uiImage,
            for: .normal
        )
    }
}

// MARK: Setup

private extension AddPlantButtonCell {
    func setupUI() {
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        contentView.addSubview(mainStack)

        mainStack.addArrangedSubview(titleStack)
        mainStack.addArrangedSubview(accessoryButton)
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subtitleLabel)
    }

    func setupConstraints() {
        mainStack.pinToSuperviewEdges(
            edges: [
                .top(VerticalSpacing.pt16),
                .bottom(-VerticalSpacing.pt16),
                .left(HorizontalSpacing.pt22),
                .right(-HorizontalSpacing.pt22)
            ]
        )
        titleStack.pinToSuperviewEdges(
            edges: [
                .left(HorizontalSpacing.pt16)
            ]
        )
        NSLayoutConstraint.activate([
            accessoryButton.heightAnchor.constraint(equalToConstant: Constants.accesorySize),
            accessoryButton.widthAnchor.constraint(equalToConstant: Constants.accesorySize)
        ])
    }
}

// MARK: Views makers

private extension AddPlantButtonCell {
    func makeMainStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.stackSpacing

        return stack
    }

    func makeTitleStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical

        return stack
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()

        return label
    }

    func makeSubtitleLabel() -> UILabel {
        let label = UILabel()

        return label
    }

    func makeAccessoryButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        button.backgroundColor = Color.matteGreen
        button.tintColor = .white
        button.layer.cornerRadius = Constants.accesorySize / 2
        button.addTarget(self, action: #selector(onFavouriteButtonTap), for: .touchUpInside)

        return button
    }

    @objc
    func onFavouriteButtonTap() {
        model?.onFavouriteButtonTap()
    }
}
