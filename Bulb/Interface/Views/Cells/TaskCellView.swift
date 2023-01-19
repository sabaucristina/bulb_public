//
//  TaskCellViewTableViewCell.swift
//  Bulb
//
//  Created by Sabau Cristina on 07/06/2022.
//

import UIKit

class TaskCellView: UITableViewCell {
    static let identifierName = String(describing: type(of: TaskCellView.self))
    private lazy var containerView = UIView()
    private lazy var textStackView = UIStackView()
    private lazy var selectionAccessoryView = makeSelectionAccessory()
    private lazy var snoozeAccessoryView = makeSnoozeAccessory()
    private lazy var completedTaskAccessoryView = makeCompletedTaskImageView()
    private lazy var accessoryLabelContainer = makeAccessoryLabelContainer()
    private lazy var accessoryLabel = makeAccessoryLabel()
    private lazy var accessoryStackView = UIStackView()
    private lazy var taskImage = makeTaskImage()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var subtitleLabel = makeSubtitleLabel()
    private lazy var tagLabel = makeTagLabel()
    private lazy var tagContainer = makeTagContainer()
    private var model: Model?

    enum Constants {
        static let tagHeight: CGFloat = 30
        static let tagWidth: CGFloat = 60
        static let tagFontSize: CGFloat = 12
        static let tagMargins: CGFloat = 5
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with model: Model) {
        self.model = model
        if model.isUpcomingTask {
            accessoryStackView.isHidden = true
        } else {
            accessoryStackView.isHidden = false
            accessoryLabelContainer.isHidden = !(model.isSkipped || model.isSnoozed) || model.isCompleted
            completedTaskAccessoryView.isHidden = !model.isCompleted
            snoozeAccessoryView.isHidden = model.isCompleted || model.isSkipped || model.isSnoozed
            selectionAccessoryView.isHidden = model.isCompleted || model.isSkipped || model.isSnoozed
        }

        titleLabel.text = model.plantName
        subtitleLabel.text = model.taskType.capitalized

        accessoryLabel.attributedText = NSAttributedString(
            string: model.isSkipped ? "Skipped" : "Snoozed" ,
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: Constants.tagFontSize),
                    .foregroundColor: UIColor.black.withAlphaComponent(0.8)
                ]
            )

        if let tagText = model.tagText {
            tagContainer.isHidden = false
            tagLabel.attributedText = NSAttributedString(
                string: tagText,
                attributes: [
                    .font: UIFont.boldSystemFont(ofSize: Constants.tagFontSize),
                    .foregroundColor: UIColor.white
                ]
            )
        } else {
            tagContainer.isHidden = true
        }
    }
}

private extension TaskCellView {
    func setupUI() {
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        accessoryStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        textStackView.axis = .vertical
        accessoryStackView.axis = .horizontal
        accessoryStackView.spacing = HorizontalSpacing.pt8
    }

    func setupHierarchy() {
        contentView.addSubview(containerView)
        contentView.addSubview(tagContainer)
        tagContainer.addSubview(tagLabel)
        accessoryLabelContainer.addSubview(accessoryLabel)

        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subtitleLabel)

        containerView.addSubview(taskImage)
        containerView.addSubview(accessoryStackView)
        containerView.addSubview(textStackView)

        accessoryStackView.addArrangedSubview(completedTaskAccessoryView)
        accessoryStackView.addArrangedSubview(snoozeAccessoryView)
        accessoryStackView.addArrangedSubview(selectionAccessoryView)
        accessoryStackView.addArrangedSubview(accessoryLabelContainer)
    }

    func setupConstraints() {
        containerView.pinToSuperviewEdges()

        taskImage.pinToSuperviewEdges(
            edges: [
                .top(VerticalSpacing.pt10),
                .bottom(-VerticalSpacing.pt10),
                .left(HorizontalSpacing.pt16)
            ]
        )

        textStackView
            .leftAnchor
            .constraint(
                equalTo: taskImage.rightAnchor, constant: HorizontalSpacing.pt16
            ).isActive = true
        textStackView
            .centerYAnchor
            .constraint(equalTo: taskImage.centerYAnchor).isActive = true
        textStackView
            .rightAnchor
            .constraint(
                lessThanOrEqualTo: accessoryStackView.leftAnchor, constant: -HorizontalSpacing.pt8
            ).isActive = true

        tagLabel.pinToSuperviewEdges(
            edges: [
                .top(Constants.tagMargins),
                .bottom(-Constants.tagMargins),
                .left(Constants.tagMargins),
                .right(-Constants.tagMargins)
            ]
        )
        NSLayoutConstraint.activate([
            taskImage.heightAnchor.constraint(equalToConstant: ImageSize.imageSize),
            taskImage.widthAnchor.constraint(equalTo: taskImage.heightAnchor),

            tagContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.tagMargins),
            tagContainer.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: Constants.tagMargins),
            tagContainer.widthAnchor.constraint(lessThanOrEqualToConstant: Constants.tagWidth)
        ])

        setupAccessoryViewConstraints()
    }

    func setupAccessoryViewConstraints() {
        accessoryLabel.pinToSuperviewEdges(
            edges: [
                .left(HorizontalSpacing.pt16),
                .right(-HorizontalSpacing.pt16)
            ]
        )
        accessoryStackView.pinToSuperviewEdges(
            edges: [.right(-HorizontalSpacing.pt16)])

        NSLayoutConstraint.activate([
            accessoryStackView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            accessoryLabel.centerYAnchor.constraint(equalTo: accessoryLabelContainer.centerYAnchor),
            selectionAccessoryView.heightAnchor.constraint(equalToConstant: ImageSize.iconSize),
            selectionAccessoryView.widthAnchor.constraint(equalTo: selectionAccessoryView.heightAnchor),

            snoozeAccessoryView.heightAnchor.constraint(equalToConstant: ImageSize.iconSize),
            snoozeAccessoryView.widthAnchor.constraint(equalTo: snoozeAccessoryView.heightAnchor),

            completedTaskAccessoryView.heightAnchor.constraint(equalToConstant: ImageSize.iconSize),
            completedTaskAccessoryView.widthAnchor.constraint(equalTo: completedTaskAccessoryView.heightAnchor)
        ])
    }
}

private extension TaskCellView {
    func makeTaskImage() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.image = Image.plantIcon.uiImage

        imageView.layer.borderWidth = 3.0
        imageView.layer.borderColor = Color.matteGreen.cgColor
        imageView.layer.cornerRadius = ImageSize.imageSize / 2
        imageView.clipsToBounds = true

        return imageView
    }

    func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = Array(repeating: "Plant Name", count: 30).joined()

        return label
    }

    func makeSubtitleLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Color.matteGreen
        label.text = "Task Name"

        return label
    }

    func makeSelectionAccessory() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let image = Image.circle.uiImage
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(onTapComplete), for: .touchUpInside)

        return button
    }

    func makeSnoozeAccessory() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        let image = Image.snooze.uiImage

        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(onTapSnooze), for: .touchUpInside)

        return button
    }

    @objc
    func onTapSnooze() {
        model?.onAction?(.snooze)
    }

    @objc
    func onTapComplete() {
        model?.onAction?(.complete)
    }

    func makeCompletedTaskImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Image.checkmarkFill.uiImage
        imageView.tintColor = Color.darkMatteGreen

        return imageView
    }

    func makeTagLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }

    func makeTagContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .systemRed
        view.layer.cornerRadius = Constants.tagHeight / 2

        return view
    }

    func makeAccessoryLabelContainer() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = Color.matteGreen.withAlphaComponent(0.5)
        view.layer.cornerRadius = 10

        return view
    }

    func makeAccessoryLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0

        return label
    }
}
