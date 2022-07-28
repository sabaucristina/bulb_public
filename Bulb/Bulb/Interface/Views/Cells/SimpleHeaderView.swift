//
//  SimpleHeaderView.swift
//  Bulb
//
//  Created by Sabau Cristina on 12/06/2022.
//

import Foundation
import UIKit

final class SimpleHeaderView: UITableViewHeaderFooterView {
    static let identifierName = String(describing: type(of: SimpleHeaderView.self))
    private lazy var titleLabel = makeTitleLabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        titleLabel.pinToSuperviewEdges(
            edges: [.left(HorizontalSpacing.pt22)]
        )
    }

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

private extension SimpleHeaderView {
    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }
}
