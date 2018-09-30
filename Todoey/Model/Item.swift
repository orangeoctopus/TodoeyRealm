//
//  Item.swift
//  TodoeyRealm
//
//  Created by Telstra on 28/9/18.
//  Copyright © 2018 Orange Octopus. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date? //make optional
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //inverse relationships - many to one for categrpy - propety is property from categpry
}
