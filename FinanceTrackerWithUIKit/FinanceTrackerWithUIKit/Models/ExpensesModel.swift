//
//  ExpensesModel.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 17.11.23.
//

import Foundation
import RealmSwift

class Expenses: Object {
    @Persisted var category:Category?
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var amount: Double = 0.0
}

struct ExpenseSection {
    let date: Date
    let expenses: [Expenses]
}
