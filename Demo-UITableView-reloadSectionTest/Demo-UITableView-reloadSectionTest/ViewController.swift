//
//  ViewController.swift
//  Demo-UITableView-reloadSectionTest
//
//  Created by Kristina Gelzinyte on 10/25/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cellID = "MyCellId"
    var dataSource = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)

        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func delete(at index: Int) {
        self.dataSource.remove(at: index)
        
        self.tableView.performBatchUpdates( {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }, completion: nil)
    }
    
    func duplicate(at index: Int) {
        self.dataSource.insert(index + 1, at: index)

        self.tableView.performBatchUpdates( {
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }, completion: nil)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = "\(self.dataSource[indexPath.item])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let duplicateAction = UITableViewRowAction(style: .normal, title: "Duplicate") { (action, indexPath) in
            self.duplicate(at: indexPath.item)
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.delete(at: indexPath.item)
        }

        return [deleteAction, duplicateAction]
    }
}
