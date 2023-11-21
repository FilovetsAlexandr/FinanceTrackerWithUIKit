//
//  CategoryModel.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 20.11.23.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name = ""
    @Persisted var color = ""
    @Persisted var amount: Double = 0.0
    let subCategories = List<SubCategory>()
}

class SubCategory: Object {
    @Persisted var name = ""
    @Persisted var amount: Double = 0.0
}
