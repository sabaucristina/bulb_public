//
//  SimpleButtonCell.swift
//  Bulb
//
//  Created by Sabau Cristina on 28/06/2022.
//

import Foundation
import UIKit

final class TaskActionCell: UITableViewCell {
    static let identifierName = String(describing: type(of: TaskActionCell.self))
    private lazy var container = UIStackView()
    private lazy var mainActionButton = makeMainActionButton()
    private lazy var moreActionButton = makeMoreActionsButton()
    private var model: Model?

    enum Constants {
        static let buttonHeight: CGFloat = 40
        static let mainButtonWidth: CGFloat = 80
        static let titleFontSize: CGFloat = 18
    }

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .horizontal
        container.spacing = HorizontalSpacing.pt8

        container.addArrangedSubview(mainActionButton)
        container.addArrangedSubview(moreActionButton)

        contentView.addSubview(container)

        moreActionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        moreActionButton.widthAnchor.constraint(equalToConstant: Constants.buttonHeight).isActive = true
        container.pinToSuperviewEdges(
            edges: [
                .right(-HorizontalSpacing.pt22),
                .left(HorizontalSpacing.pt22),
                .top(VerticalSpacing.pt22),
                .bottom(-VerticalSpacing.pt22)]

        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: Model) {
        self.model = model
        moreActionButton.isHidden = model.isUpcomingTask
        mainActionButton.setAttributedTitle(
            NSAttributedString(
                string: model.title,
                attributes: [
                    .font: UIFont.systemFont(ofSize: Constants.titleFontSize)]
            ),
            for: .normal
        )
    }
}

private extension TaskActionCell {
    func makeMainActionButton() -> UIButton {
        let button = SimpleButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)

        return button
    }

    func makeMoreActionsButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Image.moreOptions.uiImage, for: .normal)
        button.tintColor = Color.darkMatteGreen
        button.layer.borderWidth = 2
        button.layer.borderColor = Color.matteGreen.cgColor
        button.layer.cornerRadius = Constants.buttonHeight / 2
        button.addTarget(self, action: #selector(moreActionsTapped), for: .touchUpInside)

        return button
    }

    @objc
    func mainButtonTapped() {
        model?.onTap()
    }
    @objc
    func moreActionsTapped() {
        model?.onTapMoreActions?()
    }
}
