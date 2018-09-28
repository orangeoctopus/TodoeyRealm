//
//  Data.swift
//  TodoeyRealm
//
//  Created by Telstra on 28/9/18.
//  Copyright © 2018 Orange Octopus. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = "" //declaration modifier - use dynamic dispatch over standard dispatch - allows this to be monitored while app running - i.e. if name changes in running it allows name to be updated in db
    @objc dynamic var age: Int = 0
}
