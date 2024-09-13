//
//  ContentView.swift
//  To-Do-List(iOS)
//
//  Created by kunal more on 13/09/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \ListModel.list_name) private var All_lists: [ListModel]
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    //@StateObject private var lists = Lists() // Use @StateObject for Lists
    @State private var listname: String = ""
    @State private var isAddingList: Bool = false
    
    var body: some View {
        NavigationStack{
            Group{
                VStack {
                    HStack {
                        Image(systemName: "note")
                            .imageScale(.large)
                            .foregroundStyle(.green)
                        Text("To-Do-List")
                            .font(.largeTitle)
                            .bold()
                            .foregroundStyle(.green)
                    }
                    .padding()
                    if All_lists.isEmpty {
                        ContentUnavailableView("Add new lists", systemImage: "list.bullet.clipboard.fill")
                            .foregroundStyle(.green)
                        // Show input field and save button when 'Add List' is pressed
                        if isAddingList {
                            NavigationStack{
                                Form{
                                    HStack {
                                        TextField("Enter List Name", text: $listname)
                                        
                                        Button("Save") {
                                            if !self.listname.isEmpty {
                                                let newList = ListModel(list_name: listname)
                                                context.insert(newList)
                                                self.listname = ""
                                                self.isAddingList = false
                                                dismiss()
                                            }
                                        }
                                        .buttonStyle(.bordered)
                                        .cornerRadius(14)
                                        .padding(.leading)
                                        .foregroundStyle(.primary)
                                    }
                                }
                                .presentationDetents([.medium])
                            }
                        }
                    }else{
                        List {
                            // Display all lists
                            ForEach(All_lists) { all_list in
                                NavigationLink(destination: ListView(list_name: all_list.list_name)){
                                    HStack{
                                        Text(all_list.list_name)
                                            .font(.title2)
                                            .foregroundStyle(.black)
                                        Spacer()
                                        let count = String(all_list.item_count)
                                        Text(count)
                                            .font(.subheadline)
                                            .foregroundStyle(.green)
                                    }
                                }.navigationTitle("Lists of tasks")
                                
                            }.onDelete{ indexSet in
                                indexSet.forEach{ index in
                                    let del_list = All_lists[index]
                                    context.delete(del_list)
                                }
                            }
                        }.listStyle(.plain)
                        if isAddingList {
                            NavigationStack{
                                
                                Form{
                                    
                                    HStack {
                                        TextField("Enter List Name", text: $listname)
                                        
                                        Button("Save") {
                                            if !self.listname.isEmpty {
                                                let newList = ListModel(list_name: listname)
                                                context.insert(newList)
                                                self.listname = ""
                                                self.isAddingList = false
                                                dismiss()
                                            }
                                        }
                                        .padding(.leading)
                                        .foregroundStyle(.green)
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }.toolbar{
                // Conditionally show buttons based on the state
                if isAddingList {
                    // Replace with a different button or image
                    Button {
                        // Perform some other action if necessary
                        print("Another button pressed")
                        // Reset the state to bring back the original button if needed
                        self.isAddingList = false
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(.green)
                    }
                } else {
                    // Original 'Add List' button
                    Button {
                        self.isAddingList = true // Toggle the state to replace the button
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(for: ListModel.self, inMemory: true)
    }
}
