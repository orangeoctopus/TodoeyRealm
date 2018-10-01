//
//  Category.swift
//  TodoeyRealm
//
//  Created by Telstra on 28/9/18.
//  Copyright © 2018 Orange Octopus. All rights reserved.
//

import Foundation
import RealmSwift
import SwipeCellKit

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() //realm type for many relationships
}
