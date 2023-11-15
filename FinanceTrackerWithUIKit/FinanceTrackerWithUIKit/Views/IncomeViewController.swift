//
//  IncomeViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 14.11.23.
//

import UIKit

class IncomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Добавим код для настройки вида IncomeViewController
        view.backgroundColor = .white
        title = "Income"
        tabBarItem = UITabBarItem(title: "Income", image: UIImage(systemName: "chart.bar.fill"), tag: 1)
    }
}
