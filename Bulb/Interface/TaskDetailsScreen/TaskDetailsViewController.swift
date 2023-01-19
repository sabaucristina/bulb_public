//
//  TaskDetailsViewController.swift
//  Bulb
//
//  Created by Sabau Cristina on 14/06/2022.
//

import Foundation
import UIKit

final class TaskDetailsViewController: UITableViewController {
    private let viewModel: TaskDetailsViewModel

    init(
        viewModel: TaskDetailsViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItems()
        setupTableView()
        viewModel.reloadData()
    }
}

// MARK: Setup UI
private extension TaskDetailsViewController {
    func setupNavigationItems() {
        title = viewModel.navTitle()
        navigationItem.rightBarButtonItem = .init(
            image: Image.close.uiImage,
            style: .plain,
            target: self,
            action: #selector(closeSheet)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    @objc
    func closeSheet() {
        dismiss(animated: true)
    }

    func setupTableView() {
        tableView.register(
            SimpleCell.self,
            forCellReuseIdentifier: SimpleCell.identifierName
        )
        tableView.register(
            TaskActionCell.self,
            forCellReuseIdentifier: TaskActionCell.identifierName
        )
        tableView.register(
            SimpleHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SimpleHeaderView.identifierName
        )

        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
    }
}

extension TaskDetailsViewController {
    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        viewModel.numberOfSections()
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cellModel = viewModel.cellModel(indexPath: indexPath)

        let cell = tableView.dequeueReusableCell(
            withIdentifier: cellModel.identifier,
            for: indexPath
        )

        switch cellModel {
        case .simple(let model):
            (cell as? SimpleCell)?.update(with: model)
        case .text(let model):
            (cell as? TextViewCell)?.update(with: model)
        case .actions(let model):
            (cell as? TaskActionCell)?.update(with: model)
        }

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {

        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SimpleHeaderView.identifierName
        )
        let title = viewModel.sectionTitle(section: section)
        let model = SimpleHeaderView.Model.init(title: title)

        (header as? SimpleHeaderView)?.update(with: model)

        return header
    }
}
