//
//  DataManager.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 11.11.23.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {
    static let shared = StorageManager()

    static func getAllExpenses() -> Results<Expenses> { realm.objects(Expenses.self) }

    static func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("deleteAll error: \(error)")
        }
    }

    static func deleteExpenses(expenses: Expenses) {
        do {
//            let realm = try Realm()
            try realm.write {
                realm.delete(expenses)
            }
        } catch {
            print("deleteExpenses error: \(error)")
        }
    }

    static func editExpenses(expenses: Expenses, newExpenseName: String) {
        do {
            try realm.write {
                expenses.name = newExpenseName
            }
        } catch {
            print("editeTasksList error: \(error)")
        }
    }

    static func saveExpenses(expenses: Expenses) {
        do {
//            let realm = try Realm()
            try realm.write {
                realm.add(expenses)
            }
        } catch {
            print("Error saving expenses: \(error)")
        }
    }

    static func editExpenses(expenses: Expenses,
                             newName: String,
                             newNote: String)
    {
        do {
            try realm.write {
                expenses.name = newName
                expenses.note = newNote
            }
        } catch {
            print("editTask error: \(error)")
        }
    }

    static func findRealmFile() {
        print("Realm is located at:", realm.configuration.fileURL!)
    }

    static func deleteExpense(expense: Expenses) {
        try! realm.write {
            realm.delete(expense)
        }
    }
}
