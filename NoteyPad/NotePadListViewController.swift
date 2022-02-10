//
//  ViewController.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 14/01/2022.
//

import UIKit
import RealmSwift

class NotePadListViewController: UITableViewController {

    var noteArray: Results<Note>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.autocapitalizationType = .none
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCellType", for: indexPath) as! NoteCell
        
        cell.textLabel?.text = noteArray?[indexPath.row].title ?? "No Notes Added."
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        cell.dateAndTime.text = formatter.string(from: (noteArray?[indexPath.row].dateCreated!)!)
        
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let note = noteArray?[indexPath.row] {
            
            if editingStyle == .delete {
                RealmManager.sharedInstance.delete(object: note)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
        
    // MARK: - Add new note
    
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
