//
//  Category.swift
//  Todoey
//
//  Created by Phill on 13/02/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
