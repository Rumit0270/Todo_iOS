//
//  TodoListViewController.swift
//  TODO
//
//  Created by Mac on 6/23/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListVC: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var items: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customizeView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        guard let originalColor = UIColor(hexString: "1D9BF6") else { return }
        customizeNavBar(with: originalColor)
    }
    
    private func customizeView() {
        if let hexColorString = selectedCategory?.cellColor, let hexColor = UIColor(hexString: hexColorString), let itemTitle = selectedCategory?.name {
            title = itemTitle
            searchBar.barTintColor = hexColor
            customizeNavBar(with: hexColor)
        }
    }
    
    private func customizeNavBar(with color: UIColor) {
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.tintColor = ContrastColorOf(color, returnFlat: true)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(color, returnFlat: true)]

    }
    
    // MARK: - Table view data source methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = items?[indexPath.row], let gradientColor = selectedCategory?.cellColor {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            let darkenPercentage = CGFloat(indexPath.row) / CGFloat(items!.count)
            if let color = UIColor(hexString: gradientColor)?.darken(byPercentage: darkenPercentage) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
        } else {
            cell.textLabel?.text = "No items added!"
        }
        
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedItem = items?[indexPath.row] {
            do {
                try realm.write {
                    // Update a model
                    selectedItem.done = !selectedItem.done
                }
            } catch {
                print("Error updating item done state: \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        // remove the item from the data model
        guard let selectedItem = items?[indexPath.row] else {
            return
        }
        
        do {
            try realm.write {
                // Delete a model
                realm.delete(selectedItem)
            }
        } catch {
            print("Error deleting the item: \(error)")
        }
    }
    
    // MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new To-do item:", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            guard let newItem = textField.text, newItem.count > 0, let currentCategory = self.selectedCategory else {
                return
            }
            
            do {
                try self.realm.write {
                    let item = Item()
                    item.title = newItem
                    item.dateCreated = Date()
                    currentCategory.items.append(item)
                }
            } catch {
                print("Error saving new item: \(error)")
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadItems() {
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension TodoListVC: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else {
            return
        }

        if query.count == 0 {
            loadItems()
        } else {
            items = items?.filter("title contains[cd] %@", query).sorted(byKeyPath: "dateCreated", ascending: true)
        }
        tableView.reloadData()
        view.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
