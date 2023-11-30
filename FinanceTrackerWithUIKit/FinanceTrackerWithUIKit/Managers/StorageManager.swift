//
//  DataManager.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 11.11.23.
//

import Foundation
import RealmSwift

class StorageManager {
     let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to instantiate Realm: \(error)")
        }
    }
    
    static let shared = StorageManager()
    
    func getAllExpenses() -> Results<Expenses> {
        return realm.objects(Expenses.self)
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("deleteAll error: \(error)")
        }
    }
    
    func deleteExpenses(expenses: Expenses) {
        do {
            try realm.write {
                realm.delete(expenses)
            }
        } catch {
            print("deleteExpenses error: \(error)")
        }
    }
    
    func editExpenses(expenses: Expenses, newExpenseName: String) {
        do {
            try realm.write {
                expenses.name = newExpenseName
            }
        } catch {
            print("editExpenses error: \(error)")
        }
    }
    
    func saveExpenses(expenses: Expenses) {
        do {
            try realm.write {
                realm.add(expenses)
            }
        } catch {
            print("Error saving expenses: \(error)")
        }
    }
    
    func editExpenses(expenses: Expenses, newName: String, newNote: String) {
        do {
            try realm.write {
                expenses.name = newName
                expenses.note = newNote
            }
        } catch {
            print("editExpenses error: \(error)")
        }
    }
    
    func findRealmFile() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    func deleteExpense(expense: Expenses) {
        do {
            try realm.write {
                realm.delete(expense)
            }
        } catch {
            print("deleteExpense error: \(error)")
        }
    }
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("create error: \(error)")
        }
    }
}
