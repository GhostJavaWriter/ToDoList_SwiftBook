//
//  TasksViewController.swift
//  ToDoList_1
//
//  Created by Bair Nadtsalov on 5.11.2022.
//

import UIKit

class TasksViewController: UIViewController {
    
// MARK: - Properties
    
    private let reuseIdentifier = String(describing: UITableViewCell.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = .pagesBackgroundColor
        
        return tableView
    }()
    
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        title = "Tasks"
        view.backgroundColor = .pagesBackgroundColor
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        //addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
    // MARK: Actions

    @objc func addButtonTapped() {
        
    }
}

// MARK: - UITableViewDelegate

extension TasksViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = "Cell number \(indexPath.row)"
        contentConfig.textProperties.color = .white
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
}

