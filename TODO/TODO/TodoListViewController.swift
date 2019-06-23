//
//  ViewController.swift
//  TODO
//
//  Created by Mac on 6/23/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let items = ["Bug Milk", "Feed cats", "go for a walk"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
}

