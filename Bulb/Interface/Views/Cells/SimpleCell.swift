//
//  SimpleCell.swift
//  Bulb
//
//  Created by Sabau Cristina on 17/06/2022.
//

import Foundation
import UIKit

final class SimpleCell: UITableViewCell {
    static let identifierName = String.init(describing: type(of: SimpleCell.self))
    private lazy var container = makeContainerView()
    private lazy var descriptionLabel = makeDescriptionLabel()

    enum Constants {
        static let containerHeight: CGFloat = 100
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        container.addSubview(descriptionLabel)
        contentView.addSubview(container)
        container.pinToSuperviewEdges(
            edges: [
                .right(-HorizontalSpacing.pt22),
                .left(HorizontalSpacing.pt22),
                .top(VerticalSpacing.pt22),
                .bottom(-VerticalSpacing.pt22)
            ]
        )

        container.heightAnchor.constraint(equalToConstant: Constants.containerHeight).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        descriptionLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        descriptionLabel.center = container.center
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: Model) {
        descriptionLabel.attributedText = NSAttributedString(
            string: model.descriptionText,
            attributes: [
                .font: model.textFont
            ]
        )
    }

    func makeContainerView() -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.borderWidth = 2
        container.layer.borderColor = Color.matteGreen.cgColor
        container.layer.cornerRadius = Constants.containerHeight / 4

        return container
    }

    func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0

        return label
    }
}
