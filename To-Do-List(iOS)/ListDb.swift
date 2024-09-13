//
//  ListDb.swift
//  To-Do-List(iOS)
//
//  Created by kunal more on 25/09/24.
//

import Foundation
import SQLite3

class DatabaseManager {
    var db: OpaquePointer? //optional
    
    init() {
        openDatabase()
    }
    
    //Creating the database.....
    func openDatabase() {
        let fileURL = try! FileManager.default
            .url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            .appendingPathComponent(
                "ToDoList.sqlite"
            )
        if sqlite3_open(
            fileURL.path,
            &db
        ) != SQLITE_OK {
            print(
                "Error opening database"
            )
        }else{
            print(
                "Database opened successfully at \(fileURL.path)"
            )
        }
        createListTable()
    }
    
    //Creating List table....
    func createListTable(){
        let createTableQuery = """
                CREATE TABLE IF NOT EXISTS List_table (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    list_name TEXT NOT NULL
                );
                """
        
        if sqlite3_exec(db, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error creating List_table: \(errmsg)")
        }else{
            print("List_table created successfully.")
        }
    }
    
    func fetchListNames() -> [String] {
        var lists = [String]()
        let query = "SELECT list_name FROM List_table;"
        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            while sqlite3_step(stmt) == SQLITE_ROW {
                if let cString = sqlite3_column_text(stmt, 0) {
                    let name = String(cString: cString)
                    print("Name in the list is \(name)")
                    lists.append(name)
                }
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error fetching list names: \(errmsg)")
        }

        sqlite3_finalize(stmt)
        return lists
    }

    
    func addListName(_ name: String) {
        let insertQuery = "INSERT INTO List_table (list_name) VALUES (?);"
        var stmt: OpaquePointer?

        if sqlite3_prepare_v2(db, insertQuery, -1, &stmt, nil) == SQLITE_OK {
            sqlite3_bind_text(stmt, 1, name, -1, nil)

            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Successfully inserted list name: \(name)")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Error inserting list name: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing insert statement: \(errmsg)")
        }

        sqlite3_finalize(stmt)
    }

    func printAllLists() {
        let query = "SELECT * FROM List_table;"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, query, -1, &stmt, nil) == SQLITE_OK {
            print("List of names in List_table:")
            while sqlite3_step(stmt) == SQLITE_ROW {
                if let cString = sqlite3_column_text(stmt, 1) { // Assuming name is the second column (index 1)
                    let name = String(cString: cString)
                    print(name) // Print each name to the debug console
                }
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error fetching list names: \(errmsg)")
        }
        
        sqlite3_finalize(stmt)
    }


    func dropTable(tableName: String) {
        guard db != nil else {
            print("Database is not open.")
            return
        }
        
        let dropTableQuery = "DROP TABLE IF EXISTS \(tableName);"
        let resultCode = sqlite3_exec(db, dropTableQuery, nil, nil, nil)
        
        if resultCode == SQLITE_OK {
            print("Table \(tableName) dropped successfully.")
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            let errorCode = sqlite3_errcode(db)
            print("Error dropping table: \(errmsg) (Error Code: \(errorCode))")
        }
        createListTable()
    }


    
    func closeDatabase() {
        if sqlite3_close(db) != SQLITE_OK {
            print("Error closing database")
        } else {
            print("Database closed successfully")
        }
    }
}
