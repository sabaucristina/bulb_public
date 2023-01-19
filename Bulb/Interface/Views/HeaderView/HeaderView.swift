//
//  HeaderView.swift
//  Bulb
//
//  Created by Sabau Cristina on 28/11/2022.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    static let identifierName = String(describing: type(of: HeaderView.self))
    private lazy var titleLabel = makeTitleLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.pinToSuperviewEdges(
            edges: [
                .bottom(-VerticalSpacing.pt5),
                .left(HorizontalSpacing.pt22)
            ]
        )
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: Model) {
        titleLabel.attributedText = NSAttributedString(
            string: model.title.uppercased(),
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: model.fontSize)
            ]
        )
    }
}

private extension HeaderView {
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
}
