//
//  CategoryModel.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 20.11.23.
//

import Foundation
import RealmSwift

final class Category: Object {
    @Persisted var name = ""
    @Persisted var imageName : String?
}
