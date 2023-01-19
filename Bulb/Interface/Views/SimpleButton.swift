//
//  HoverButton.swift
//  Bulb
//
//  Created by Sabau Cristina on 29/04/2022.
//

import Foundation
import UIKit

final class SimpleButton: UIButton {

    private var model: Model?
    enum Constants {
        enum Colors {
            static let backgroundColor = UIColor.white
            static let shadowColor = Color.matteGreen.cgColor
            static let titleColor = UIColor.black
        }

        enum ContentSize {
            static let height: CGFloat = 42
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = Constants.ContentSize.height/2
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 1.0
        layer.shadowColor = Constants.Colors.shadowColor
        layer.masksToBounds = false
    }

    func update(model: Model) {
        self.model = model
        setAttributedTitle(
            NSAttributedString(
                string: model.title,
                attributes: [
                    .font: SystemFont.ofSize18pt,
                    .foregroundColor: Constants.Colors.titleColor
                ]
            ),
            for: .normal
        )
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Constants.Colors.backgroundColor
        addTarget(self, action: #selector(tapped), for: .touchUpInside)

        heightAnchor.constraint(equalToConstant: Constants.ContentSize.height).isActive = true
        widthAnchor.constraint(equalToConstant: Constants.ContentSize.height * 5).isActive = true
    }

    @objc
    func tapped() {
        model?.action()
    }
}
