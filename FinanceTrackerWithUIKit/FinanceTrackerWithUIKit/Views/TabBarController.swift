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
                let expensesViewController = ExpensesViewController()
                let incomeViewController = IncomeViewController()
                let chartsViewController = ChartsViewController()
                
                let expensesNavigationController = UINavigationController(rootViewController: expensesViewController)
                let incomeNavigationController = UINavigationController(rootViewController: incomeViewController)
                let chartsNavigationController = UINavigationController(rootViewController: chartsViewController)
                
                expensesNavigationController.tabBarItem = UITabBarItem(title: "Expenses", image: UIImage(systemName: "basket.fill"), tag: 0)
                incomeNavigationController.tabBarItem = UITabBarItem(title: "Income", image: UIImage(systemName: "dollarsign.circle.fill"), tag: 1)
                chartsNavigationController.tabBarItem = UITabBarItem(title: "Charts", image: UIImage(systemName: "chart.pie.fill"), tag: 2)
                
                viewControllers = [expensesNavigationController, incomeNavigationController, chartsNavigationController]
        // Установка цветов таб-бара
                tabBar.tintColor = .tabBarItemAccent
                tabBar.barTintColor = .mainWhite
    }
    
//    private func generateTabBar() {
//        viewControllers = [
//            generateVC(viewController: ExpensesViewController(), title: "Expenses", image: UIImage(systemName: "basket.fill")),
//            generateVC(viewController: IncomeViewController(), title: "Income", image: UIImage(systemName: "dollarsign.circle.fill")),
//            generateVC(viewController: ChartsViewController(), title: "Charts", image: UIImage(systemName: "chart.pie.fill"))
//            
//            ]
//        }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
//    private func setTabBarAppearance() {
//        let appearance = UITabBarAppearance()
//        appearance.backgroundColor = UIColor.mainWhite
//        
//        let itemAppearance = UITabBarItemAppearance()
//        itemAppearance.normal.iconColor = UIColor.tabBarItemLight
//        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tabBarItemLight]
//        itemAppearance.selected.iconColor = UIColor.tabBarItemAccent
//        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tabBarItemAccent] // Установка цвета для надписей выбранных элементов
//        
//        appearance.stackedLayoutAppearance = itemAppearance
//        appearance.inlineLayoutAppearance = itemAppearance
//        
//        tabBar.standardAppearance = appearance
//    }
}

