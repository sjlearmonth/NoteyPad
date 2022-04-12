//
//  ViewController.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 14/01/2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class NotePadListViewController: SwipeTableViewController {
    
    var noteArray: Results<Note>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: Properties
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        configureNavigationBar()
        
    }
    
    // MARK: Helper Methods
    
    
    
    private func configureNavigationBar() {
        
        if let hexColor = selectedCategory?.color1 {
            
            self.title = selectedCategory!.name

            guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")}

            if let backgroundColor = UIColor(hexString: hexColor) {
                
                let contrastColor = ContrastColorOf(backgroundColor, returnFlat: true)
                
                let navBarAppearance = UINavigationBarAppearance()
                
                navBarAppearance.backgroundColor = backgroundColor
                navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: contrastColor]
                navBar.scrollEdgeAppearance = navBarAppearance
                
                navBar.tintColor = contrastColor
                
//                navigationItem.rightBarButtonItem?.tintColor = ContrastColorOf(backgroundColor, returnFlat: true)
                
                searchBar.barTintColor = UIColor(hexString: hexColor)
                searchBar.searchTextField.backgroundColor = contrastColor
                searchBar.searchTextField.textColor = UIColor(hexString: hexColor)
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func configureSearchBar() {
        
        searchBar.autocapitalizationType = .none
        
    }
        
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! NoteCell
        
        cell.textLabel?.text = noteArray?[indexPath.row].title ?? "No Notes Added."
        
        let percentage = CGFloat(indexPath.row) / CGFloat(noteArray!.count)
        print("DEBUG: percentage = \(percentage)")
        if let color = UIColor(hexString: selectedCategory?.color1 ?? "7F7F7F") {
            cell.backgroundColor = color.darken(byPercentage: percentage)
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor ?? UIColor.white, returnFlat: true)
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_GB")
        cell.dateAndTime.text = formatter.string(from: (noteArray?[indexPath.row].dateCreated!)!)
        cell.dateAndTime.textColor = ContrastColorOf(cell.backgroundColor ?? UIColor.white, returnFlat: true)
        
        return cell
    }
    
    // MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let noteView = NoteView(frame: CGRect(x: (self.view.frame.width - 240.0)/2.0, y: (self.view.frame.height - 300.0)/2.0, width: 240.0, height: 300.0))
        
        noteView.savedNote = noteArray?[indexPath.row]
        view.addSubview(noteView)
        
        noteView.delegate = self
        
    }
            
    // MARK: - Delete Note Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let noteForDeletion = self.noteArray?[indexPath.row] {
            do {
                try RealmManager.sharedInstance.delete(object: noteForDeletion)
            } catch {
                print("DEBUG: Error deleting note: \(error)")
            }
        }
    }

    // MARK: - Add New Note
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
        let createNoteView = NoteView(frame: CGRect(x: (self.view.frame.width - 240.0)/2.0, y: (self.view.frame.height - 300.0)/2.0, width: 240.0, height: 300.0))
        
        createNoteView.savedNote = nil
        
        view.addSubview(createNoteView)
        
        createNoteView.delegate = self
        
    }
    
    func loadItems() {
        
        noteArray = selectedCategory?.notes.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

// MARK: - Note View Protocol

extension NotePadListViewController: NoteViewProtocol {

    func send(note: Note) {
        if let currentCategory = selectedCategory {
            if note.row == -1 {
                note.row = noteArray?.count ?? 0
                
                RealmManager.sharedInstance.update {
                    currentCategory.notes.append(note)
                }
            } else {
                RealmManager.sharedInstance.update {
                    let row = note.row
                    currentCategory.notes[row] = note
                }
            }
        }
        tableView.reloadData()
    }
}

// MARK: - SearchBar delegate methods

extension NotePadListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        noteArray = noteArray?.filter("title CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
