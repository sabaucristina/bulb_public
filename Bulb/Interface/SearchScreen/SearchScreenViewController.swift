//
//  SearchScreenViewController.swift
//  Bulb
//
//  Created by Sabau Cristina on 31/05/2022.
//

import Foundation
import UIKit

final class SearchScreenViewController: UIViewController {
    private lazy var tableView = UITableView()
    private lazy var searchController = makeSearchController()
    private let viewModel: SearchScreenViewModel

    init(
        viewModel: SearchScreenViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init() {
        self.init(viewModel: SearchScreenViewModel())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()

        viewModel.onAction = { [weak self] action in
            guard let self = self else { return }
            switch action {
            case .reload:
                self.tableView.reloadData()
            case let .handleError(error):
                self.tableView.reloadData()
                self.view.displayError(error: error)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willAppear()
    }
}

private extension SearchScreenViewController {
    func setupUI() {
        view.addSubview(tableView)
        setupTableView()
        navigationItem.searchController = searchController
    }

    func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.pinToSuperviewEdges()

        tableView.register(
            PlantViewCell.self,
            forCellReuseIdentifier: PlantViewCell.identifierName
        )

        tableView.register(
            SegmentedControlCell.self,
            forCellReuseIdentifier: SegmentedControlCell.identifierName
        )

        tableView.register(
            SimpleBannerCell.self,
            forCellReuseIdentifier: SimpleBannerCell.identifierName
        )

        tableView.dataSource = self
        tableView.delegate = self
    }

    func makeSearchController() -> UISearchController {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search your plant"

        return search
    }
}

// MARK: TableView DataSource & Delegate
extension SearchScreenViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.numbersOfRowsInSection()
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell: UITableViewCell
        let cellModel = viewModel.cellModel(for: indexPath)

        switch cellModel {
        case let .segmentedControl(model):
            cell = tableView.dequeueReusableCell(
                withIdentifier: SegmentedControlCell.identifierName,
                for: indexPath
            )
            (cell as? SegmentedControlCell)?.update(model: model)
        case let .plantItem(model):
            cell = tableView.dequeueReusableCell(
                withIdentifier: PlantViewCell.identifierName,
                for: indexPath
            )
            (cell as? PlantViewCell)?.update(with: model)
        case let .simpleBanner(model):
            cell = tableView.dequeueReusableCell(
                withIdentifier: SimpleBannerCell.identifierName,
                for: indexPath
            )
            (cell as? SimpleBannerCell)?.update(with: model)
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.onTapCell(for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchScreenViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        viewModel.setSearchText(searchTerm: text)
    }
}
