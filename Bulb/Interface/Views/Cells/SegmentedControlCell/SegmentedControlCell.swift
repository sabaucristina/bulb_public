//
//  SegmentedControlCell.swift
//  Bulb
//
//  Created by Sabau Cristina on 28/10/2022.
//

import UIKit

final class SegmentedControlCell: UITableViewCell {
    static let identifierName = String(describing: type(of: SegmentedControlCell.self))
    private lazy var segmentedControl = makeSegmentedControl()
    private var model: Model?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(segmentedControl)
        selectionStyle = .none
        segmentedControl.pinToSuperviewEdges(
            edges: [
                .left(HorizontalSpacing.pt16),
                .right(-HorizontalSpacing.pt16),
                .top(VerticalSpacing.pt10),
                .bottom(-VerticalSpacing.pt10)
            ]
        )
    }

    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(model: Model) {
        self.model = model
        segmentedControl.removeAllSegments()
        for (index, item) in model.availableCategories.enumerated() {
            segmentedControl.insertSegment(
                withTitle: item,
                at: index,
                animated: false
            )
        }
        segmentedControl.selectedSegmentIndex = model.selectedCategoryIndex ?? 0
    }
}

private extension SegmentedControlCell {
    func makeSegmentedControl() -> UISegmentedControl {
        let segmentedControl = UISegmentedControl()
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentedControlHasChanged), for: .valueChanged)

        return segmentedControl
    }

    @objc
    func segmentedControlHasChanged() {
        let selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        model?.onSegmentedControlHasChanged(selectedSegmentIndex)
    }
}
