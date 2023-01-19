//
//  SimpleBannerCell.swift
//  Bulb
//
//  Created by Sabau Cristina on 05/07/2022.
//

import Foundation
import UIKit

final class SimpleBannerCell: UITableViewCell {
    static let identifierName = String(describing: type(of: SimpleBannerCell.self))

    private lazy var container = makeBannerContainer()
    private lazy var title = makeTitleLabel()
    private lazy var image = makeIconView()

    enum Constants {
        static let colorBlack: UIColor = .black.withAlphaComponent(0.7)
        static let cellHeight: CGFloat = 200
        static let imageSize: CGFloat = 50
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none

        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: Model) {
        image.image = model.icon.uiImage
        title.text = model.title
    }

    func setupHierarchy() {
        contentView.addSubview(container)

        container.addArrangedSubview(title)
        container.addArrangedSubview(image)
    }

    func setupConstraints() {
        container.pinToSuperviewEdges(
            edges: [
                .top(VerticalSpacing.pt16),
                .bottom(-VerticalSpacing.pt16),
                .right(-HorizontalSpacing.pt16),
                .left(HorizontalSpacing.pt16)
            ])
        let constraints = [
            contentView.heightAnchor.constraint(lessThanOrEqualToConstant: Constants.cellHeight),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: VerticalSpacing.pt22),
            image.heightAnchor.constraint(equalToConstant: Constants.imageSize),
            image.widthAnchor.constraint(equalToConstant: Constants.imageSize),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -VerticalSpacing.pt22)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func makeBannerContainer() -> UIStackView {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.axis = .vertical
        container.alignment = .center
        container.spacing = 10

        return container
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = Constants.colorBlack

        return label
    }

    func makeIconView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Constants.colorBlack

        return imageView
    }
}
