//
//  TransactionRealm.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 10.11.23.
//

import UIKit
import RealmSwift

class TransactionRealm: Object {
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var type: String = ""
    @objc dynamic var category: String = ""
    @objc dynamic var date: Date = Date()
}
