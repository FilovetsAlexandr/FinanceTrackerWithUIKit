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
    
    static func getAllExpensesList() -> Results<ExpensesList> {
        realm.objects(ExpensesList.self)
    }

    static func deleteExpensesList(expensesList: ExpensesList) {
        do {
            try realm.write {
                let expenses = expensesList.expenses
                // последовательно удаляем expenses, а затем там ExpensesList
                realm.delete(expenses)
                realm.delete(expensesList)
            }
        } catch {
            print("deleteTasksList error: \(error)")
        }
    }
    static func editExpensesList(expensesList: ExpensesList, newListName: String) {
        do {
            try realm.write {
                expensesList.name = newListName
            }
        } catch {
            print("editeTasksList error: \(error)")
        }
    }

    static func saveExpensesList(expensesList: ExpensesList) {
        do {
            try realm.write {
                realm.add(expensesList)
            }
        } catch {
            print("saveTasksList error: \(error)")
        }
    }
    
    static func saveExpenses(expensesList: ExpensesList, expenses: Expenses) {
        do {
            try realm.write {
                expensesList.expenses.append(expenses)
            }
        } catch {
            print("saveTask error: \(error)")
        }
    }
    
    static func editExpenses(expenses: Expenses,
                             newName: String,
                             newNote: String) {
        do {
            try realm.write {
                expenses.name = newName
                expenses.note = newNote
            }
        } catch {
            print("editTask error: \(error)")
        }
    }
    
    static func deleteExpenses(expenses: Expenses) {
        do {
            try realm.write {
                realm.delete(expenses)
            }
        } catch {
            print("deleteTask error: \(error)")
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
