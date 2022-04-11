//
//  Category.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 04/02/2022.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String?
    let notes = List<Note>()
}
