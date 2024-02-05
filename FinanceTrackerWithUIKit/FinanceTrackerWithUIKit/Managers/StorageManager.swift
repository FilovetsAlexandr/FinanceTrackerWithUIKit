//
//  DataManager.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 11.11.23.
//

import Foundation
import RealmSwift

final class StorageManager {
    
    static let shared = StorageManager()
    private let realm = try! Realm()
    
    /// General Manager
    
    private func findRealmFile() { print("Realm is located at:", realm.configuration.fileURL!) }
    
    private func addCategory(name: String, imageName: String) {
        let category = Category()
        category.name = name
        category.imageName = imageName
        
        try! realm.write { realm.add(category) }
    }
    
    private func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("deleteAll error: \(error)")
        }
    }
    
    /// Storage Manager for Expense
    
    func getAllExpenses() -> Results<Expenses> { realm.objects(Expenses.self) }
    
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
            try realm.write { realm.add(object) }
        } catch {
            print("create error: \(error)")
        }
    }
    
    private func searchExpenses(with searchText: String) -> Results<Expenses> {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR category.name CONTAINS[cd] %@", searchText, searchText)
        return realm.objects(Expenses.self).filter(predicate)
    }
    
    private func deleteExpenses(expenses: Expenses) {
        do {
            try realm.write {
                realm.delete(expenses)
            }
        } catch {
            print("deleteExpenses error: \(error)")
        }
    }
    
    private func updateExpense(expense: Expenses) {
        try! realm.write {
            realm.add(expense, update: .modified)
        }
    }
    
    /// Storage Manager for Income
    
    func getAllIncomes() -> Results<Incomes> { realm.objects(Incomes.self) }
    
    func deleteIncome(income: Incomes) {
        do {
            try realm.write {
                realm.delete(income)
            }
        } catch {
            print("Error delete income: \(error)")
        }
    }
    
    func saveIncomes(incomes: Incomes) {
        do {
            try realm.write {
                realm.add(incomes)
            }
        } catch {
            print("Error saving incomes: \(error)")
        }
    }
    
    func editIncomes(incomes: Incomes, newName: String, newNote: String, newCategory: Category, newAmount: Double, newDate: Date) {
        do {
            try realm.write {
                incomes.name = newName
                incomes.note = newNote
                incomes.category = newCategory
                incomes.amount = newAmount
                incomes.date = newDate
            }
        } catch {
            print("Error editing incomes:\(error)")
        }
    }
    
    private func searchIncomes(with searchText: String) -> Results<Incomes> {
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@ OR category.name CONTAINS[cd] %@", searchText, searchText)
        return realm.objects(Incomes.self).filter(predicate)
    }
    
    private func deleteIncomes(incomes: Incomes) {
        do {
            try realm.write {
                realm.delete(incomes)
            }
        } catch {
            print("Error deleting incomes: \(error)")
        }
    }
    
    private func updateIncome(income: Incomes) { try! realm.write { realm.add(income, update: .modified) } }
}
