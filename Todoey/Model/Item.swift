//
//  Item.swift
//  Todoey
//
//  Created by Telstra on 21/9/18.
//  Copyright © 2018 Orange Octopus. All rights reserved.
//

import Foundation

class Item: Codable{
    //in wsift 4 - codable = Encodable , Decodable
    //for tem to be encodable properties need to be standard data types
    var title: String = ""
    var done: Bool = false
}
