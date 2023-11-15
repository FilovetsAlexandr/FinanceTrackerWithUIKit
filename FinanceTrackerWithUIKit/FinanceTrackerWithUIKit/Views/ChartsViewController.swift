//
//  ChartsViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 10.11.23.
//

import UIKit

class ChartsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Добавим код для настройки вида ChartsViewController
        view.backgroundColor = .white
        title = "Charts"
        tabBarItem = UITabBarItem(title: "Charts", image: UIImage(systemName: "chart.pie.fill"), tag: 2)
    }
}
