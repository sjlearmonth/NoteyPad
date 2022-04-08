//
//  RealmManager.swift
//  NoteyPad
//
//  Created by Stephen Learmonth on 10/02/2022.
//

import Foundation
import RealmSwift

class RealmManager {
    
    private var realm: Realm

    static let sharedInstance = RealmManager()

    private init() {
        realm = try! Realm()
    }

    func add(object: Object, shouldUpdate: Bool = true) {
        try! realm.write {
            if shouldUpdate {
                realm.add(object, update: .all)
            } else {
                realm.add(object)
            }
        }
    }
    
    func update(action: () -> Void) {
        try! realm.write {
            action()
        }
    }

    func deleteAll() {
        try! realm.write {
            realm.deleteAll()
        }
    }

    func delete(object: Object) throws {
        do {
            try realm.write {
            realm.delete(object)
            }
        } catch {
                throw error
        }
    }
    
    func fetch<Element>(_ type: Element.Type) -> Results<Element> where Element : RealmFetchable {
        let realm = try! Realm()
        return realm.objects(type)
    }
}

