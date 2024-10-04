import SwiftUI
import SwiftData

struct ListView: View {
    // Filter by list
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @State private var itemname: String = ""
    @State private var isAddingItem: Bool = false
    @State var list: ListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "note")
                        .imageScale(.large)
                        .foregroundColor(.green)
                    Text(list.list_name)
                        .font(.title)
                        .bold()
                        .foregroundColor(.green)
                }
                .padding()
                
                if list.items.isEmpty {
                    ContentUnavailableView("Add Task in this \(list.list_name)", systemImage: "list.bullet.clipboard.fill")
                        .foregroundColor(.green)
                    
                    if isAddingItem {
                        taskInputField
                    }
                } else {
                    List {
                        ForEach(list.items.indices, id: \.self) { item in
                            HStack {
                                Text(list.items[item])
                                    .font(.title2)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }.onDelete{indexSet in
                            indexSet.forEach{ index in
                                list.items.remove(at: index)
                                self.list.item_count -= 1
                            }
                        }
                        if isAddingItem {
                            taskInputField
                        }
                    }.listStyle(.plain)
                }
            }
            .toolbar {
                toolbarContent
            }
            .padding()
        }
    }
    
    // Input field for adding new tasks
    private var taskInputField: some View {
        HStack {
            TextField("Enter Item Name", text: $itemname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Save") {
                if !self.itemname.isEmpty {
                    self.list.items.append(itemname)
                    self.list.item_count += 1
                    self.itemname = "" // Clear input
                    self.isAddingItem = false// Hide input field
                }
            }
            .padding(.leading)
            .foregroundColor(.green)
        }
    }
    
    // Toolbar content for adding or canceling task addition
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            if isAddingItem {
                Button {
                    self.isAddingItem = false // Cancel adding task
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.green)
                }
            } else {
                Button {
                    self.isAddingItem = true // Show input field for adding task
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.green)
                }
            }
        }
    }
}
