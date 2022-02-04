//
//  Note.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 04/02/2022.
//

import Foundation
import RealmSwift

class Note: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var row: Int = 0
    var parentCategory = LinkingObjects(fromType: Category.self, property: "notes")
}
