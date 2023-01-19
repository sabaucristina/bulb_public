//
//  TaskAddDetailsViewController.swift
//  Bulb
//
//  Created by Sabau Cristina on 29/06/2022.
//

import Foundation
import UIKit

final class TaskAddDetailsViewController: UITableViewController {

    private var task: Task
    private lazy var simpleButtonModel = makeSimpleButtonModel()
    private lazy var saveButton = SimpleButton()
    private lazy var notes = makeTextViewModel()

    init(
        task: Task
    ) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}
// MARK: SetupUI
private extension TaskAddDetailsViewController {
    func setupUI() {
        setupNavigationItems()
        setupTableView()

        saveButton.update(model: simpleButtonModel)
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        saveButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    }

    func setupNavigationItems() {
        title = "Add details"
        navigationItem.rightBarButtonItem = .init(
            image: Image.close.uiImage,
            style: .plain,
            target: self,
            action: #selector(closeSheet)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }

    func setupTableView() {
        tableView.register(
            TextViewCell.self,
            forCellReuseIdentifier: TextViewCell.identifierName
        )
        tableView.register(
            SimpleHeaderView.self,
            forHeaderFooterViewReuseIdentifier: SimpleHeaderView.identifierName
        )
        tableView.keyboardDismissMode = .onDrag
        tableView.addSubview(saveButton)
    }
}

// MARK: Helper Methods
private extension TaskAddDetailsViewController {
    @objc
    func closeSheet() {
        dismiss(animated: true)
    }
}

// MARK: Cell Models
private extension TaskAddDetailsViewController {
    func makeTextViewModel() -> TextViewCell.Model {
        .init(
            placeholder: "(Add notes here)",
            text: task.notes
        )
    }

    func makeSimpleButtonModel() -> SimpleButton.Model {
        .init(
            title: "Save",
            action: { [weak self] in
                guard let self = self else { return }

                TaskService().updateTask(
                    with: self.task.id,
                    data: ["notes": self.notes.text ?? ""]
                ) { result in
                    switch result {
                    case .success:
                        self.dismiss(animated: true)
                    case .failure(let error):
                        print("failll\(error)")
                    }
                }
            }
        )
    }
}

// MARK: TableView - DataSource & Delegate
extension TaskAddDetailsViewController {
    override func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        return 1
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        1
    }
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: TextViewCell.identifierName,
            for: indexPath
        )
        (cell as? TextViewCell)?.update(with: notes)

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: SimpleHeaderView.identifierName
        )
        let model = SimpleHeaderView.Model.init(title: "Notes")

        (header as? SimpleHeaderView)?.update(with: model)

        return header
    }
}
