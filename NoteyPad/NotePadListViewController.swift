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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.setEditing(true, animated: true)
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

        createNoteView.delegate = self
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            context.delete(itemArray[indexPath.row])
            itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // do something
            
            let createNoteView = CreateNoteView(frame: CGRect(x: (self.view.frame.width - 240.0)/2.0, y: (self.view.frame.height - 300.0)/2.0, width: 240.0, height: 300.0))

            createNoteView.savedNote = nil

            view.addSubview(createNoteView)

            createNoteView.delegate = self

        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 {
            return .insert
        } else if indexPath.row == itemArray.count - 1 {
            return .insert
        } else {
            return .delete
        }
    }
    
    // MARK: - Add new note
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
            
        let createNoteView = CreateNoteView(frame: CGRect(x: (self.view.frame.width - 240.0)/2.0, y: (self.view.frame.height - 300.0)/2.0, width: 240.0, height: 300.0))
        
        createNoteView.savedNote = nil
        
        view.addSubview(createNoteView)
        
        createNoteView.delegate = self
        
    }
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving items: \(error)")
        }
    }
    
    func loadItems() {
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error)")
        }
    }
}

// MARK: - Create Note View Protocol

extension NotePadListViewController: CreateNoteViewProtocol {
    
    func send(note: Note) {
        
        if note.row == -1 {
            note.row = Int16(itemArray.count)
            itemArray.append(note)
        } else {
            itemArray[Int(note.row)] = note
        }
        saveItems()
        tableView.reloadData()
    }
}
