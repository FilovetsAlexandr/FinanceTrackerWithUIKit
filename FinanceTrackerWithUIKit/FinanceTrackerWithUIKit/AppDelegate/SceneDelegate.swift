//
//  SceneDelegate.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 10.11.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let expensesViewController = ExpensesViewController()
        let incomeViewController = IncomeViewController()
        let chartsViewController = ChartsViewController()

        let expensesNavController = UINavigationController(rootViewController: expensesViewController)
        let incomeNavController = UINavigationController(rootViewController: incomeViewController)
        let chartsNavController = UINavigationController(rootViewController: chartsViewController)

        expensesNavController.navigationBar.prefersLargeTitles = true
        incomeNavController.navigationBar.prefersLargeTitles = true
        chartsNavController.navigationBar.prefersLargeTitles = true

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [expensesNavController, incomeNavController, chartsNavController]

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
