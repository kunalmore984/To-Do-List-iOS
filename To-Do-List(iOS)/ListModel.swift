//
//  ListModel.swift
//  To-Do-List(iOS)
//
//  Created by kunal more on 27/09/24.
//

import Foundation
import SwiftData

@Model
class ListModel{
    var list_name: String
    var item_count: Int
    
    init(list_name: String, item_count: Int = 0) {
        self.list_name = list_name
        self.item_count = item_count
    }
}
