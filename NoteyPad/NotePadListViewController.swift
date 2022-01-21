//
//  ViewController.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 14/01/2022.
//

import UIKit

class NotePadListViewController: UITableViewController {

    var itemArray = [Note(title: "My Day", content: "Got up, had a shower, got dressed, ..."), Note(title: "My Marriage", content: "OK, this is how I see my marriage these days, ..."), Note(title: "Alfie", content: "Alfie is my dog, he is a large size mixed breed from Romania, ...")]
    
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
//        print("Did select item: \(itemArray[indexPath.row])")
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        // To turn off selection color use:
//        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        
        let createNoteView = CreateNoteView(frame: CGRect(x: (self.view.frame.width - 240.0)/2.0, y: (self.view.frame.height - 300.0)/2.0, width: 240.0, height: 300.0))
        
        createNoteView.savedNoteTitle = itemArray[indexPath.row].title
        createNoteView.savedNoteContent = itemArray[indexPath.row].content

        view.addSubview(createNoteView)
        createNoteView.delegate = self

    }
    
    // MARK: - Add new note
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let createNoteView = CreateNoteView(frame: CGRect(x: (self.view.frame.width - 240.0)/2.0, y: (self.view.frame.height - 300.0)/2.0, width: 240.0, height: 300.0))
        
        view.addSubview(createNoteView)
        
        createNoteView.delegate = self
        
    }
}

extension NotePadListViewController: CreateNoteViewProtocol {
    func send(title: String, content: String) {
        let note = Note(title: title, content: content)
        itemArray.append(note)
        tableView.reloadData()
    }
}
