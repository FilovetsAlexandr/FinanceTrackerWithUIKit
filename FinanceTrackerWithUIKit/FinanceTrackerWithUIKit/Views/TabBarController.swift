//
//  ViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 14.11.23.
//
import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let expensesViewController = ExpensesViewController()
        let incomeViewController = IncomeViewController()
        let chartsViewController = ChartsViewController()
        
//        expensesViewController.tabBarItem = UITabBarItem(title: "Expenses", image: UIImage(systemName: "dollarsign.circle"), tag: 0)
//        incomeViewController.tabBarItem = UITabBarItem(title: "Income", image: UIImage(systemName: "chart.bar.fill"), tag: 1)
//        chartsViewController.tabBarItem = UITabBarItem(title: "Charts", image: UIImage(systemName: "chart.pie.fill"), tag: 2)
        
        viewControllers = [expensesViewController, incomeViewController, chartsViewController]
    }
}
