//
//  ViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 14.11.23.
//

import UIKit
import Lottie

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let expensesListViewController = ExpensesListViewController()
        let incomeViewController = IncomeViewController()
        let chartsViewController = ChartsViewController()
                
        let expensesListNavigationController = UINavigationController(rootViewController: expensesListViewController)
        let incomeNavigationController = UINavigationController(rootViewController: incomeViewController)
        let chartsNavigationController = UINavigationController(rootViewController: chartsViewController)
                
        expensesListNavigationController.tabBarItem = UITabBarItem(title: "Расходы", image: UIImage(systemName: "basket.fill"), tag: 0)
        incomeNavigationController.tabBarItem = UITabBarItem(title: "Доходы", image: UIImage(systemName: "dollarsign.circle.fill"), tag: 1)
        chartsNavigationController.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "chart.pie.fill"), tag: 2)
                
        viewControllers = [expensesListNavigationController, incomeNavigationController, chartsNavigationController]
        
        // Установка цветов таб-бара
        tabBar.tintColor = .tabBarItemAccent
        tabBar.barTintColor = .mainWhite
    }
}

