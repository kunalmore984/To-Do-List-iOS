//
//  ContentView.swift
//  To-Do-List(iOS)
//
//  Created by kunal more on 13/09/24.
//

import SwiftUI
import SwiftData

struct ListContentView: View {
    @Query(sort: \ListViewModel.list_name) private var All_lists: [ListViewModel]
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
                                    textinput
                                }
                                .presentationDetents([.medium])
                            }
                        }
                    }else{
                        List {
                            // Display all lists
                            ForEach(All_lists) { all_list in
                                NavigationLink(destination: ListView(list: all_list)){
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
                                    .presentationDetents([.large])
                                
                            }.onDelete{ indexSet in
                                indexSet.forEach{ index in
                                    let del_list = All_lists[index]
                                    All_lists[index].items.removeAll()
                                    All_lists[index].item_count = 0
                                    try? context.save()
                                    context.delete(del_list)
                                    
                                }
                            }
                        }.listStyle(.plain)
                        if isAddingList {
                            NavigationStack{
                                Form{
                                    textinput
                                }
                            }
                        }
                    }
                    
                }
            }.toolbar{
                // Conditionally show buttons based on the state
                toolbarcontent
            }
        }
        
    }
    private var textinput: some View {
        HStack {
            TextField("Enter List Name", text: $listname)
            
            Button("Save") {
                if !listname.isEmpty {
                    let newList = ListViewModel(list_name: listname)
                    context.insert(newList)
                    listname = ""
                    isAddingList = false
                    dismiss()
                }
            }
            .buttonStyle(.bordered)
            .cornerRadius(14)
            .padding(.leading)
            .foregroundStyle(.primary)
        }
    }
    
    private var toolbarcontent: some ToolbarContent{
        ToolbarItemGroup(placement: .navigationBarTrailing) {
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




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ListContentView()
            .modelContainer(for: ListViewModel.self, inMemory: true)
    }
}
