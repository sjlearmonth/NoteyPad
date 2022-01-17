//
//  ViewController.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 14/01/2022.
//

import UIKit

class NotePadListViewController: UITableViewController {

    let itemArray = ["Must speak to Peter about this code.", "Remember to meet Jane for coffee.", "Ask vet about Alphie's need to dig all the time.", "Dear diary, here's what I did today."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteyItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
}

