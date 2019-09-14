//
//  CategoriesTableViewController.swift
//  TODO
//
//  Created by Mac on 6/23/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import RealmSwift

class CategoriesTableVC: SwipeTableViewController {
    
    let realm = try! Realm()
    
    // Results are auto updating container in Realm
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        tableView.rowHeight = 80
    }

    // MARK: - Table view data source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No categories added yet"
        
        return cell
    }
    
    // MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoItems" {
            let destinationVC = segue.destination as! TodoListVC
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        }
    }
    
    // MARK: - Data model manipulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context!")
        }
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: - Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        guard let selectedCategory = categories?[indexPath.row] else { return }

        do {
            try realm.write {
                realm.delete(selectedCategory)
            }
        } catch {
            print("Error deleting category: \(error)")
        }
    }

   
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Todo Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            guard let categoryName = textField.text else {
                return
            }
            
            guard categoryName.count > 0 else {
                return
            }
            
            // create a new Real Category model
            let category = Category()
            category.name = categoryName
            
            self.save(category: category)
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
