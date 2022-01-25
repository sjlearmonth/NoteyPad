//
//  ViewController.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 14/01/2022.
//

import UIKit

class NotePadListViewController: UITableViewController {

    var itemArray = Array<Note>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteyItemCell", for: indexPath)
        
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
    
    // MARK: - Add new note
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let createNoteView = CreateNoteView(frame: CGRect(x: (self.view.frame.width - 240.0)/2.0, y: (self.view.frame.height - 300.0)/2.0, width: 240.0, height: 300.0))
        
        createNoteView.savedNote = nil
        
        view.addSubview(createNoteView)
        
        createNoteView.delegate = self
        
    }
}

extension NotePadListViewController: CreateNoteViewProtocol {
    func send(note: Note) {
        
        if note.row == nil {
            let note = Note(title: note.title, content: note.content, row: itemArray.count)
            itemArray.append(note)
        } else {
            itemArray[note.row!] = note
        }
        
        tableView.reloadData()
    }
}
