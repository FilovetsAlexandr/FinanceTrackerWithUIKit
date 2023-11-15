//
//  ExpensesViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 14.11.23.
//

import UIKit

class ExpensesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Добавим код для настройки вида ExpensesViewController
        view.backgroundColor = .white
        title = "Expenses"
        if let expensesImage = UIImage(named: "expenses.png") {
            let resizedImage = expensesImage.resized(to: CGSize(width: 30, height: 30))
            // Изменяем размер изображения
            tabBarItem = UITabBarItem(title: "Expenses", image: resizedImage, tag: 0)
        }
    }
}

// Расширение для изменения размера изображения
extension UIImage {
    func resized(to newSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}


