//
//  CategoryViewController.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 25/01/2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categories = Array<Category>()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    // MARK: - TableView Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "fromCategoryToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! NotePadListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        } catch {
            print("Error saving categories: \(error)")
        }
        
        self.tableView.reloadData()
    }

    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading categories: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { action in
            
            if textField.text != "" {
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                self.categories.append(newCategory)
                self.saveCategories()
            }
        }
        
        alertController.addTextField { alertTextField in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
            alertTextField.addTarget(self, action: #selector(self.editingChangedHandler), for: .editingChanged)
        }
        
        alertController.addAction(alertAction)
        alertController.actions[0].isEnabled = false
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func editingChangedHandler(_ sender: Any) {
        let textField = sender as! UITextField
        var responder : UIResponder! = textField
        while !(responder is UIAlertController) { responder = responder.next }
        let alert = responder as! UIAlertController
        alert.actions[0].isEnabled = (textField.text != "")
    }
}
