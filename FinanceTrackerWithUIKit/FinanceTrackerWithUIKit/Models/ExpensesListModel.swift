//
//  ExpensesListModel.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 17.11.23.
//

import Foundation
import RealmSwift

class ExpensesList: Object {
    @Persisted var name = ""
    @Persisted var date = Date()
    @Persisted var expenses = List<Expenses>()
}
