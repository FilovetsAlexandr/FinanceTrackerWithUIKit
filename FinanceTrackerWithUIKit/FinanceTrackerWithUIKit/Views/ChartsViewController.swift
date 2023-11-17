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
        setupUI()
    }
    private func setupUI() {
        title = "Charts"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
    }
}

