//
//  File.swift
//  Bulb
//
//  Created by Sabau Cristina on 12/05/2022.
//

import Foundation
import UIKit

final class HomeScreenViewController: UIViewController {
    private lazy var segmentedControl = makeSegmentedControl()
    private lazy var tableView = UITableView()
    private let viewModel: HomeScreenViewModel

    init(
        viewModel: HomeScreenViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(
            viewModel: HomeScreenViewModel()
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        setupTableView()
        viewModel.onAction = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case let .handleError(error):
                self.view.displayError(error: error)
            case .reload:
                self.tableView.reloadData()
            }
        }
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshTasks()
    }

    @objc
    func logOut() {
        viewModel.logOut()
        view.window?.rootViewController = RootControllerFactory.makeOnboardingController()
    }
}

// MARK: Helper Methods
private extension HomeScreenViewController {
    func setupUI() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = .init(
            image: Image.logOut.uiImage,
            style: .plain,
            target: self, action: #selector(logOut)
        )

        view.addSubview(tableView)
        tableView.pinToSuperviewEdges()
    }

    func makeSegmentedControl() -> UISegmentedControl {
        let segment = UISegmentedControl(
            items: TaskCategory.allCases.map { $0.type.capitalized }
        )
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = viewModel.taskCategory.rawValue
        segment.addTarget(self, action: #selector(segmentHasChanged), for: .valueChanged)

        return segment
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            SimpleHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SimpleHeaderView.identifierName
        )
        tableView.register(
            TaskCellView.self,
            forCellReuseIdentifier: TaskCellView.identifierName
        )
        tableView.register(
            SimpleBannerCell.self,
            forCellReuseIdentifier: SimpleBannerCell.identifierName
        )

        tableView.dataSource = self
        tableView.delegate = self
    }

    @objc
    func segmentHasChanged() {
        if let task = TaskCategory(rawValue: segmentedControl.selectedSegmentIndex) {
            viewModel.taskCategory = task
            viewModel.refreshTasks()
        }
    }
}

// MARK: TableView DataSource & Delegate
extension HomeScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        viewModel.numberOfSections()
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numberOfRowsInSection(section: section)
    }
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        guard let headerModel = viewModel.headerModel(section: section) else {
            return nil
        }

        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SimpleHeaderView.identifierName
        )
        (header as? SimpleHeaderView)?.update(with: headerModel)

        return header
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: UITableViewCell
        switch viewModel.cellModel(at: indexPath) {
        case let .task(model):
            cell = tableView.dequeueReusableCell(
                withIdentifier: TaskCellView.identifierName,
                for: indexPath
            )
            (cell as? TaskCellView)?.update(with: model)
        case let .banner(model):
            cell = tableView.dequeueReusableCell(
                withIdentifier: SimpleBannerCell.identifierName,
                for: indexPath
            )
            (cell as? SimpleBannerCell)?.update(with: model)
        case let .tasksCompleted(model):
            cell = tableView.dequeueReusableCell(
                withIdentifier: SimpleBannerCell.identifierName,
                for: indexPath
            )
            (cell as? SimpleBannerCell)?.update(with: model)
        }

        if indexPath.row != viewModel.numberOfRowsInSection(section: indexPath.section) - 1 {
            cell.separatorInset = UIEdgeInsets.init(
                top: 0.0,
                left: HorizontalSpacing.pt86,
                bottom: 0.0,
                right: HorizontalSpacing.pt16
            )
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.onTapCell(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
