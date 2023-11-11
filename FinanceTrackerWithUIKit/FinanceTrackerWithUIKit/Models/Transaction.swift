//
//  Transaction.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 10.11.23.
//

import Foundation

class Transaction {
    var amount: Double
    var type: TransactionType
    var category: String
    var date: Date
    
    init(amount: Double, type: TransactionType, category: String, date: Date) {
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
    }
}

enum TransactionType {
    case expense
    case income
}
