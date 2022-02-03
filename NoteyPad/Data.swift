//
//  Data.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 03/02/2022.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}

