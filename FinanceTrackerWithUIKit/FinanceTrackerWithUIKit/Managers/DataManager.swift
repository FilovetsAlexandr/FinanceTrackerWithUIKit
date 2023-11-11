//
//  DataManager.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 11.11.23.
//

import Foundation
import RealmSwift

class DataManager {
    static let shared = DataManager()
    
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func saveTransaction(amount: Double, type: String, category: String, date: Date) {
        let realm = try! Realm()
        
        let transaction = TransactionRealm()
        transaction.amount = amount
        transaction.type = type
        transaction.category = category
        transaction.date = date
        
        do {
            try realm.write {
                realm.add(transaction)
            }
        } catch {
            print("Failed to save transaction: \(error)")
        }
    }

    
    func loadTransactions() -> Results<TransactionRealm> {
        return realm.objects(TransactionRealm.self)
    }
}
