//
//  ViewController.swift
//  TODO
//
//  Created by Mac on 6/23/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var items = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = Item()
        item1.title = "Bake cake"
        items.append(item1)
        
//        if let myItems = defaults.array(forKey: "itemArray") as? [String] {
//            items = myItems
//        }
    }
    
    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(items[indexPath.row])
        
        let selectedItem = items[indexPath.row]
        selectedItem.done = !selectedItem.done
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
//        let selectedCell = tableView.cellForRow(at: indexPath)
//        if selectedCell?.accessoryType == .checkmark {
//            selectedCell?.accessoryType = .none
//        } else {
//            selectedCell?.accessoryType = .checkmark
//        }
    }
    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new To-do item:", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            guard let newItem = textField.text else {
                return
            }
            
            guard newItem.count > 0 else {
                return
            }
            
            let item = Item()
            item.title = newItem
            item.done = false
            self.items.append(item)
           // self.defaults.set(self.items, forKey: "itemArray")
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

