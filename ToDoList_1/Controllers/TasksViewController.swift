//
//  TasksViewController.swift
//  ToDoList_1
//
//  Created by Bair Nadtsalov on 5.11.2022.
//

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
    
    private var user: Userf?
    private var ref: DatabaseReference?
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
        
        if let _user = user {
            ref = Database.database().reference(withPath: "users").child(String(_user.uid)).child("tasks")
        } else {
            //error occure
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let _ref = ref {
            _ref.observe(.value) { [weak self] snapshot in
                var _tasks = [Task]()
                for item in snapshot.children {
                    if let task = item as? DataSnapshot {
                        _tasks.append(Task(snapshot: task))
                    }
                }
                self?.tasks = _tasks
                self?.tableView.reloadData()
            }
        } else {
            print("object reference is nil")
            //error occure
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let _ref = ref {
            _ref.removeAllObservers()
        } else {
            print("object reference is nil")
            //error occure
        }
    }
    
// MARK: Support functions
    
    private func isAllowedText(text: String) -> Bool {
        //"(child:) Must be a non-empty string and not contain '.' '#' '$' '[' or ']'"
        if text == "" { return false }
        
        for symb in text {
            switch symb {
            case ".","#","$","[","]": return false
            default: return true
            }
        }
        return true
    }
    
    private func showErrorAlert(describing: String) {
        let alertController = UIAlertController(title: "Error", message: describing, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alertController, animated: true)
    }
    
// MARK: Actions

    @objc func addButtonTapped() {
        
        let alertController = UIAlertController(title: "New task", message: "What you want to do?", preferredStyle: .alert)
        alertController.addTextField()
        let addTask = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            
            guard let _self = self else { return }
            
            guard let user = _self.user else { return }
            
            guard let text = alertController.textFields?.first?.text else { return }
            if _self.isAllowedText(text: text) {
                let task = Task(title: text, userID: user.uid)
                let taskRef = self?.ref?.child(task.title.lowercased())
                
                taskRef?.setValue(task.convertToDictionary())
            } else {
                _self.showErrorAlert(describing: "Text shouldn't contain an empty string or symbols like '.' '#' '$' '[' ']')")
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        toggleCompletionCheckmark(cell: cell, isCompleted: isCompleted)
        
        task.ref?.updateChildValues(["completed": isCompleted])
    }
    
    func toggleCompletionCheckmark(cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
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
        toggleCompletionCheckmark(cell: cell, isCompleted: task.completed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
}

