//
//  ListViewModel.swift
//  To-Do-List(iOS)
//
//  Created by kunal more on 02/10/24.
//

import Foundation
import SwiftData

@Model
class ListViewModel{
    
    var list_name: String
    var items: [String] = []
    var item_count: Int
    
    init(list_name: String,item_count: Int = 0) {
        self.list_name = list_name
        self.item_count = item_count
    }
}
