//
//  To_Do_List_iOS_App.swift
//  To-Do-List(iOS)
//
//  Created by kunal more on 13/09/24.
//

import SwiftUI
import SwiftData

@main
struct To_Do_List_iOS_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ListModel.self)
    }
    
    init() {
        print("Starts here: \(URL.applicationSupportDirectory.path(percentEncoded: false))")
    }
    
}
