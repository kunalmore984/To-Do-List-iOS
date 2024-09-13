//
//  ListView.swift
//  To-Do-List(iOS)
//
//  Created by kunal more on 24/09/24.
//

import SwiftUI

struct ListView: View {
    
    struct ItemName: Identifiable {
        let id = UUID()
        var item_name: String
        var item_count: Int
    }
    struct Items {
        var item_names: [ItemName] = []
        
    }
    @State private var items = Items()
    @State private var itemname: String = ""
    @State private var isAddingItem: Bool = false
    @State var list_name: String
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "pen")
                    .imageScale(.large)
                    .foregroundStyle(.purple)
                Text(list_name)
                    .font(.title)
                    .bold()
            }.padding()
            
            Button{
                self.isAddingItem = true
            } label: {
                Text("➕ Add Item")
                    .padding()
                    .foregroundStyle(.white)
                    .background(.purple)
                    .cornerRadius(20)
            }
            List{
                ForEach(items.item_names){ itemn in
                    Itemname(Item_Name: itemn)
                }
            }
            if isAddingItem{
                HStack{
                    TextField("Enter Item Name", text: $itemname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button("Save"){
                        if !self.itemname.isEmpty {
                            self.items.item_names.append(ItemName(item_name: itemname, item_count: 0))
                            self.itemname = ""
                            self.isAddingItem = false
                        }
                    }
                    .padding()
                    .foregroundStyle(.purple)
                    .cornerRadius(20)
                }
                .padding()
            }
        }
        .padding()
    }
    
    struct Itemname: View {
        var Item_Name: ItemName
        
        var body: some View {
            VStack(alignment: .leading, spacing: 3){
                HStack(spacing: 3){
                    Text(Item_Name.item_name)
                        .foregroundColor(.primary)
                        .bold()
                    Spacer()
                    Button(action: {
                        
                    }){
                        Image(systemName: "circle")
                            .foregroundColor(.purple)
                            .padding()
                    }
                }
                .foregroundColor(.secondary)
                .font(.subheadline)
                Label(String(Item_Name.item_count),systemImage: "globe")
            }
        }
    }
}

#Preview {
    ListView(list_name: "List 1")
}
