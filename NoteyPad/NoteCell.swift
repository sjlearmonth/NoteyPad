//
//  NoteCell.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 10/02/2022.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var dateAndTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
