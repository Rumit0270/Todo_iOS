//
//  Category.swift
//  TODO
//
//  Created by Mac on 9/14/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String?
    //define the relations between Category and Item model
    let items = List<Item>()
}
