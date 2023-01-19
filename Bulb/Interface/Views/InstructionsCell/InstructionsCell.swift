//
//  InstructionsCell.swift
//  Bulb
//
//  Created by Sabau Cristina on 22/11/2022.
//

import UIKit

final class InstructionsCell: UICollectionViewCell {
    private enum Constants {
        static let mainStackMargins = UIEdgeInsets(
            top: 8,
            left: 16,
            bottom: 16,
            right: 16
        )
        static let accessorySize: CGFloat = 50
        static let titleFontSize: CGFloat = 24
        static let accessoryFontSize: CGFloat = 20
        static let instructionFontSize: CGFloat = 14
    }
    static let identifierName = String(describing: type(of: InstructionsCell.self))
    private lazy var mainStack = makeMainStack()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var firstInstructionStack = makeFirstInstructionStack()
    private lazy var secondInstructionStack = makeSecondInstructionStack()
    private lazy var firstAccessoryView = makeFirstInstructionAccesory()
    private lazy var firstAccessoryLabel = makeFirstAccessoryLabel()
    private lazy var firstAccessoryIcon = makeFirstAccesoryIcon()
    private lazy var secondAccessoryIcon = makeSecondAccesoryIcon()
    private lazy var firstInstructionLabel = makeFirstInstructionLabel()
    private lazy var secondInstructionLabel = makeSecondInstructionLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(model: Model) {
        firstInstructionStack.isHidden = model.hasASingleInstruction
        firstAccessoryIcon.isHidden = model.hasFirstAccessoryText
        firstAccessoryView.isHidden = !model.hasFirstAccessoryText
        titleLabel.attributedText = NSAttributedString(
            string: model.title,
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: Constants.titleFontSize),
                .foregroundColor: UIColor.white
            ]
        )
        firstAccessoryLabel.attributedText = NSAttributedString(
            string: model.firstAccessoryText ?? "",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: Constants.accessoryFontSize),
                .foregroundColor: UIColor.white
            ]
        )
        firstInstructionLabel.attributedText = NSAttributedString(
            string: model.firstInstructionText ?? "",
            attributes: [
                .font: UIFont.systemFont(ofSize: Constants.instructionFontSize),
                .foregroundColor: UIColor.white
            ]
        )
        firstAccessoryIcon.image = model.firstAccessoryIcon?.uiImage
        secondAccessoryIcon.image = model.secondAccessoryIcon.uiImage
        secondInstructionLabel.attributedText = NSAttributedString(
            string: model.secondInstructionText,
            attributes: [
                .font: UIFont.systemFont(ofSize: Constants.instructionFontSize),
                .foregroundColor: UIColor.white
            ]
        )
    }
}

// MARK: Setup UI

private extension InstructionsCell {
    func setupUI() {
        setupHierarchy()
        setupConstraints()
    }

    func setupHierarchy() {
        contentView.addSubview(mainStack)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.setCustomSpacing(VerticalSpacing.pt16, after: titleLabel)
        mainStack.addArrangedSubview(firstInstructionStack)
        mainStack.setCustomSpacing(VerticalSpacing.pt10, after: firstInstructionStack)
        mainStack.addArrangedSubview(secondInstructionStack)
        firstInstructionStack.addArrangedSubview(firstAccessoryView)
        firstInstructionStack.addArrangedSubview(firstAccessoryIcon)
        firstInstructionStack.addArrangedSubview(firstInstructionLabel)
        firstAccessoryView.addSubview(firstAccessoryLabel)
        secondInstructionStack.addArrangedSubview(secondAccessoryIcon)
        secondInstructionStack.addArrangedSubview(secondInstructionLabel)
    }

    func setupConstraints() {
        mainStack.pinToSuperviewEdges(
            edges: [
                .top(VerticalSpacing.pt10),
                .left(HorizontalSpacing.pt10),
                .right(-HorizontalSpacing.pt10)
            ]
        )

        firstAccessoryLabel.pinToSuperviewEdges(
            edges: [
                .top(VerticalSpacing.pt10),
                .bottom(-VerticalSpacing.pt10),
                .left(HorizontalSpacing.pt10),
                .right(-HorizontalSpacing.pt10)
            ]
        )

        NSLayoutConstraint.activate(
            [
                firstAccessoryView.heightAnchor.constraint(
                    equalToConstant: Constants.accessorySize
                ),
                firstAccessoryView.widthAnchor.constraint(
                    equalToConstant: Constants.accessorySize
                ),
                firstAccessoryIcon.heightAnchor.constraint(
                    equalToConstant: Constants.accessorySize
                ),
                firstAccessoryIcon.widthAnchor.constraint(
                    equalToConstant: Constants.accessorySize
                ),
                secondAccessoryIcon.heightAnchor.constraint(
                    equalToConstant: Constants.accessorySize
                ),
                secondAccessoryIcon.widthAnchor.constraint(
                    equalToConstant: Constants.accessorySize
                ),
                mainStack.bottomAnchor.constraint(
                    lessThanOrEqualTo: mainStack.bottomAnchor,
                    constant: -VerticalSpacing.pt10
                )
            ]
        )
    }
}

// MARK: Views makers

private extension InstructionsCell {
    func makeMainStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.layoutMargins = Constants.mainStackMargins
        stack.isLayoutMarginsRelativeArrangement = true
        stack.distribution = .fillProportionally
        contentView.backgroundColor = Color.darkMatteGreen
        contentView.layer.cornerRadius = Constants.accessorySize / 2

        return stack
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()

        return label
    }

    func makeFirstInstructionStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = VerticalSpacing.pt10

        return stack
    }

    func makeSecondInstructionStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = VerticalSpacing.pt10

        return stack
    }

    func makeFirstInstructionAccesory() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.matteGreen
        view.tintColor = .white
        view.layer.cornerRadius = Constants.accessorySize / 2

        return view
    }

    func makeFirstAccessoryLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.textAlignment = .center

        return label
    }
    func makeFirstAccesoryIcon() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.backgroundColor = Color.matteGreen
        imageView.tintColor = .white
        imageView.layer.cornerRadius = Constants.accessorySize / 2

        return imageView
    }

    func makeSecondAccesoryIcon() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.backgroundColor = Color.matteGreen
        imageView.tintColor = .white
        imageView.layer.cornerRadius = Constants.accessorySize / 2

        return imageView
    }

    func makeFirstInstructionLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .natural

        return label
    }

    func makeSecondInstructionLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .natural

        return label
    }
}
