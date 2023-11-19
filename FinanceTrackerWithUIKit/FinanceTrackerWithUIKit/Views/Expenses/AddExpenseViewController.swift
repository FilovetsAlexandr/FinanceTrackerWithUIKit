//
//  AlertForExpensesVC.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 19.11.23.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    let titleLabel = UILabel()
    let amountTextField = UITextField()
    let categoryTextField = UITextField()
    let saveButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Настройка заголовка
        titleLabel.text = "Добавить расход"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // Настройка текстового поля для ввода суммы
        amountTextField.placeholder = "Сумма"
        amountTextField.keyboardType = .decimalPad
        amountTextField.borderStyle = .roundedRect
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(amountTextField)
        
        // Настройка текстового поля для ввода категории
        categoryTextField.placeholder = "Категория"
        categoryTextField.borderStyle = .roundedRect
        categoryTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryTextField)
        
        // Настройка кнопки "Сохранить"
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.layer.cornerRadius = 8
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        // Настройка констрейнтов
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            amountTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryTextField.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            categoryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.topAnchor.constraint(equalTo: categoryTextField.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Настройка действия для кнопки "Сохранить"
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        guard let amountString = amountTextField.text,
              let amount = Double(amountString),
              let category = categoryTextField.text else { return }
        
        let expenses = Expenses()
        expenses.amount = amount
        expenses.category = category
        
        StorageManager.saveExpenses(expenses: expenses)
        
        dismiss(animated: true, completion: nil)
    }
}
