//
//  TasksViewController.swift
//  ToDoList_1
//
//  Created by Bair Nadtsalov on 5.11.2022.
//

// TODO: ask user when sign out - Are you sure? Yes/No

import UIKit
import Firebase

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
    
    private var user: Userf!
    private var ref: DatabaseReference!
    private var tasks = [Task]()
    
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        title = "Tasks"
        view.backgroundColor = .pagesBackgroundColor
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        let signOutButton = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOutTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = signOutButton
        
        //Database
        guard let currentUser = Auth.auth().currentUser else { return }
        user = Userf(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] snapshot in
            var _tasks = [Task]()
            for item in snapshot.children {
                if let task = item as? DataSnapshot {
                    _tasks.append(Task(snapshot: task))
                }
            }
            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    // MARK: Actions

    @objc func addButtonTapped() {
        
        let alertController = UIAlertController(title: "New task", message: "What you want to do?", preferredStyle: .alert)
        alertController.addTextField()
        let addTask = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let text = alertController.textFields?.first?.text,
                  text != "",
                  let user = self?.user
            else { return }
            let task = Task(title: text, userID: user.uid)
            let taskRef = self?.ref?.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDictionary())
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(addTask)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    @objc func signOutTapped() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true)
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
        
        //unwrap Task
        let task = tasks[indexPath.row]
        let taskTitle = task.title
        
        
        var contentConfig = cell.defaultContentConfiguration()
        contentConfig.text = taskTitle
        contentConfig.textProperties.color = .white
        cell.contentConfiguration = contentConfig
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
}

