//
//  Item.swift
//  TODO
//
//  Created by Mac on 6/23/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RealmSwift

//class Item: Codable {
//    var title: String = ""
//    var done: Bool = false
//}

// Object is a Real class to define the Realm model objects
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool =  false
    @objc dynamic var dateCreated: Date?
    
    // define the inverse relationship for Item
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}

