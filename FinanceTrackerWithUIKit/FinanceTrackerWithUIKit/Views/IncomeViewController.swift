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
        view.backgroundColor = .white
        setupUI()
    }

    private func setupUI() {
        title = "Доходы"
    navigationController?.navigationBar.prefersLargeTitles = true

    }
//    override func viewWillAppear(_ animated: Bool) {
//            super.viewWillAppear(animated)
//            showLoadingAnimation(view: self.view)
//        }
//
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            hideLoadingAnimation()
//        }
//
//        func showLoadingAnimation(view: UIView) {
//            animationView.isHidden = false
//            animationView.animation = LottieAnimation.named("pig")
//            animationView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
//            animationView.center = view.center
//            animationView.contentMode = .scaleAspectFill
//            animationView.loopMode = .loop
//            animationView.play()
//            view.addSubview(animationView)
//        }
//
//        func hideLoadingAnimation() {
//            animationView.stop()
//            animationView.isHidden = true
//        }
    }
