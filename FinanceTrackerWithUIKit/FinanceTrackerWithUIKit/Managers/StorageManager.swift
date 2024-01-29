//
//  DataManager.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 11.11.23.
//

import Foundation
import RealmSwift

class StorageManager {
    
    static let shared = StorageManager()
    private let realm = try! Realm()
    
    func searchExpenses(with searchText: String) -> Results<Expenses> {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR category.name CONTAINS[cd] %@", searchText, searchText)
        return realm.objects(Expenses.self).filter(predicate)
    }
    
    func addCategory(name: String, imageName: String) {
        let category = Category()
        category.name = name
        category.imageName = imageName
        
        try! realm.write {
            realm.add(category)
        }
    }
    
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
    
    func saveExpenses(expenses: Expenses) {
        do {
            try realm.write {
                realm.add(expenses)
            }
        } catch {
            print("Error saving expenses: \(error)")
        }
    }
    
    func editExpenses(expenses: Expenses, newName: String, newNote: String, newCategory: Category, newAmount: Double, newDate: Date) {
        do {
            try realm.write {
                expenses.name = newName
                expenses.note = newNote
                expenses.category = newCategory
                expenses.amount = newAmount
                expenses.date = newDate
            }
        } catch {
            print("editExpenses error: \(error)")
        }
    }
    
    func updateExpense(expense: Expenses) {
           try! realm.write {
               realm.add(expense, update: .modified)
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
