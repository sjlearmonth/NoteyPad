//
//  ViewController.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 14/01/2022.
//

import UIKit
import CoreData

class NotePadListViewController: UITableViewController {

    var itemArray = Array<Note>()
    
    var selectedCategory: Category? {
        didSet {
//            loadItems()
        }
    }

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = .none
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let createNoteView = CreateNoteView(frame: CGRect(x: (self.view.frame.width - 240.0)/2.0, y: (self.view.frame.height - 300.0)/2.0, width: 240.0, height: 300.0))

        createNoteView.savedNote = itemArray[indexPath.row]

        view.addSubview(createNoteView)

//        createNoteView.delegate = self
        
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            context.delete(itemArray[indexPath.row])
//            itemArray.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
        
    // MARK: - Add new note
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
        let createNoteView = CreateNoteView(frame: CGRect(x: (self.view.frame.width - 240.0)/2.0, y: (self.view.frame.height - 300.0)/2.0, width: 240.0, height: 300.0))
        
        createNoteView.savedNote = nil
        
        view.addSubview(createNoteView)
        
//        createNoteView.delegate = self
        
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving items: \(error)")
        }
        
        tableView.reloadData()
    }
    
//    func loadItems(using request: NSFetchRequest<Note> = Note.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context: \(error)")
//        }
//
//        tableView.reloadData()
//    }
}

// MARK: - Create Note View Protocol

//extension NotePadListViewController: CreateNoteViewProtocol {
//
//    func send(note: Note) {
//
//        if note.row == -1 {
//
//            note.row = Int16(itemArray.count)
//            note.parentCategory = selectedCategory
//            itemArray.append(note)
//
//        } else {
//
//            itemArray[Int(note.row)] = note
//
//        }
//        saveItems()
//        tableView.reloadData()
//    }
//}

// MARK: - SearchBar delegate methods

//extension NotePadListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request: NSFetchRequest<Note> = Note.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(using: request, predicate: predicate)
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        if searchText == "" {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
