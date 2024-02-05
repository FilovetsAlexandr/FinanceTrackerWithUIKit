//
//  IncomeModel.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 5.02.24.
//

import Foundation
import RealmSwift

final class Incomes: Object {
    @Persisted var category: Category?
    @Persisted var name = ""
    @Persisted var note = ""
    @Persisted var date = Date()
    @Persisted var amount: Double = 0.0
}

struct IncomeSection {
    let date: Date
    let incomes: [Incomes]
}
