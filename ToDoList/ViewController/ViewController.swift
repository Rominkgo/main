//
//  ViewController.swift
//  ToDoList
//
//  Created by Default on 12/9/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    private var viewModel: ViewModel?
    
    private let addToDo: UIButton = {
        let button = UIButton(type: .contactAdd)
        button.tintColor = .red
        return button
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tintColor = UIColor.blue
        return tableView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.transferToList()
        configureView()
        configureContraints()
        
        view.backgroundColor = .white
        tableView.reloadData()
    }
    
    
}

extension ViewController {
    @objc func addToDoItem() {
        
        let alert = UIAlertController(title: "New To Do Item", message: "Enter To Do Task", preferredStyle: .alert)
        alert.addTextField()
        let alertAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let text = alert.textFields?[0].text, !text.isEmpty else {return}
            self?.viewModel?.createToDoItem(withTitle: text)
            self?.tableView.insertRows(at: [IndexPath(row: self?.viewModel?.lastElementInList ?? 0, section: 0)], with: .fade)
            //            self?.viewModel?.save(title: text)
        }
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

// MARK: - View configuration
extension ViewController {
    //    let name: String = ""   <- cannot add new variables/constants in extensions
    
    private func configureView() {
        self.view.addSubview(tableView)
        self.view.addSubview(addToDo)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "toDoList")
        addToDo.addTarget(self, action: #selector(addToDoItem) , for: .touchDown)
        viewModel = ViewModel()
    }
    
    private func configureContraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addToDo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToDo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addToDo.leftAnchor.constraint(equalTo: view.leftAnchor),
            addToDo.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.topAnchor.constraint(equalTo: addToDo.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.toDoListCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoList", for: indexPath)
        let toDoItem = viewModel?.getToDoItem(indexPath.row)
        cell.textLabel?.text = toDoItem?.title
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let done = UITableViewRowAction(style: .normal, title: "Done") { action, index in
            let cell = tableView.cellForRow(at: indexPath) as! UITableViewCell
            self.viewModel?.markAsDone(indexPath.row)
            
            cell.accessoryType = .checkmark
            //            let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
            //            let checked = self.viewModel?.isItDone(indexPath.row)
            //            //configure you cell here.
            //            if checked! == false {
            //                cell.accessoryType = .none
            //            } else if checked! {
            //                cell.accessoryType = .checkmark
            //            }
            //            let cell = tableView.dequeueReusableCell(withIdentifier: "toDoList", for: indexPath)
            //            let toDoItem = self.viewModel?.getToDoItem(indexPath.row)
            //
            //            let cellText = toDoItem?.title ?? ""
            //            cell.textLabel?.text = cellText +  "YAY!"
            print("done button tapped")
        }
        done.backgroundColor = .green
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            self.viewModel?.removeToDoItem(indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            print("delete button tapped")
        }
        delete.backgroundColor = .red
        
        return [ done, delete]
    }
}
