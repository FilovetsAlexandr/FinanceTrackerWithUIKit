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
//        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Доходы"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
