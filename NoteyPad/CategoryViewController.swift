//
//  CategoryViewController.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 25/01/2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    // MARK: - Properties
    
    var categories: Results<Category>?
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    // MARK: Helper Methods
    
    private func configureNavigationBar() {
        
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")}
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor.systemBlue
        let contrastColor = ContrastColorOf(UIColor.systemBlue, returnFlat: true)
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
        navBar.scrollEdgeAppearance = navBarAppearance
    }

    
        
    // MARK: - TableView Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(super.tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet."
        
        if let hexString = categories?[indexPath.row].color {
            cell.backgroundColor = UIColor(hexString: hexString)
        } else {
            let color = UIColor.randomFlat()
            update(category: (categories?[indexPath.row])!, with: color)
            cell.backgroundColor = color
        }
        
        if let backgroundColor = cell.backgroundColor {
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
        }
        
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
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        RealmManager.sharedInstance.add(object: category, shouldUpdate: false)
        
        self.tableView.reloadData()
    }

    func loadCategories() {
        
        categories = RealmManager.sharedInstance.fetch(Category.self)
        
        self.tableView.reloadData()
    }
        
    private func update(category: Category, with color: UIColor) {
        
        RealmManager.sharedInstance.update() {
            category.color = color.hexValue()
        }

    }
    // MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try RealmManager.sharedInstance.delete(object: categoryForDeletion)
            } catch {
                print("DEBUG: Error deleting category: \(error)")
            }
        }
    }
    
    // MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add", style: .default) { action in
            
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                self.save(category: newCategory)
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
