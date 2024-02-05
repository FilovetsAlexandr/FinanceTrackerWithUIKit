//
//  AddIncomeViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 5.02.24.
//

import RealmSwift
import UIKit

final class AddIncomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var onSubmit: ((String, Category, String, String?) -> Void)?
    var onIncomeAdded: (() -> Void)?
    var incomeToEdit: Incomes?
  
    private let datePicker = UIDatePicker()
    private var selectedCategory: String?
    private var categoryImages = [
        "Покупки": "shopping",
        "Еда": "food",
        "Развлечения": "entertainment",
        "Подарки": "present",
        "Связь и интернет": "communication",
        "Путешествия": "travels",
        "Автомобиль": "car",
        "Дом": "house",
        "Здоровье": "health",
        "Хобби": "hobby",
        "Одежда": "clothes",
        "Техника": "drill",
        "Услуги": "ring",
        "Продукты": "sausage",
        "Алкоголь": "beer",
        "Азартные игры": "casino",
        "Долг": "duty",
        "Другое": "other",
        "Подписки": "subscriptions",
        "Такси": "taxi"
    ]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить доход"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Сумма"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата и время"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dateTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        textField.inputView = datePicker
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        textField.text = dateFormatter.string(from: Date())
        
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let commentsLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарии"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentsTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Отмена", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardDismissRecognizer()
        autocompleteField()
    }
    
    private func autocompleteField() {
        if let income = incomeToEdit {
            // Заполняем поля ввода данными из income
            amountTextField.text = "\(income.amount)"
            if let categoryName = income.category?.name {
                if categoryImages[categoryName] != nil {
                    if let categoryIndex = Array(categoryImages.keys).firstIndex(of: categoryName) {
                        categoryPicker.selectRow(categoryIndex, inComponent: 0, animated: false)
                    }
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            dateTextField.text = dateFormatter.string(from: income.date)
            
            commentsTextField.text = income.note
        }
    }
    
    private func setupUI() {
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        dateButton.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        
        // Установливаем экземпляр UIDatePicker в качестве inputView для dateTextField
        dateTextField.inputView = datePicker
        
        // Добавляем кнопку "Готово" на инструментальную панель UIDatePicker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        dateTextField.inputAccessoryView = toolbar
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(amountLabel)
        NSLayoutConstraint.activate([
            amountLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(amountTextField)
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 8),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(categoryLabel)
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 16),
            categoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(categoryPicker)
        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(commentsLabel)
        NSLayoutConstraint.activate([
            commentsLabel.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 16),
            commentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(commentsTextField)
        NSLayoutConstraint.activate([
            commentsTextField.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 8),
            commentsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: commentsTextField.bottomAnchor, constant: 16),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(dateTextField)
        NSLayoutConstraint.activate([
            dateTextField.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(dateButton)
        NSLayoutConstraint.activate([
            dateButton.centerYAnchor.constraint(equalTo: dateTextField.centerYAnchor),
            dateButton.trailingAnchor.constraint(equalTo: dateTextField.trailingAnchor, constant: -8)
        ])
        
        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, submitButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 16),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { categoryImages.keys.count }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { selectedCategory = Array(categoryImages.keys)[row] }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = Array(categoryImages.keys)[row]
        return category
    }
    
    // MARK: - Actions

    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.size.height
        
        let buttonMaxY = dateTextField.frame.maxY
        let visibleHeight = view.frame.size.height - keyboardHeight
        
        if buttonMaxY > visibleHeight {
            let offsetY = buttonMaxY - visibleHeight
            view.transform = CGAffineTransform(translationX: 0, y: -offsetY)
        } else {
            view.transform = CGAffineTransform.identity
        }
    }

    @objc private func submitButtonPressed() {
        // Получаем информацию из текстовых полей
        guard let amountText = amountTextField.text,
              let amount = Double(amountText),
              let dateText = dateTextField.text,
              let comments = commentsTextField.text,
              let selectedCategory = selectedCategory else { return }
        
        let category = Category()
        category.name = selectedCategory
        category.imageName = categoryImages[selectedCategory]
        
        let storageManager = StorageManager.shared
        
        if let incomeToEdit = incomeToEdit {
            // Обновление существующего объекта
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            if let date = dateFormatter.date(from: dateText) {
                storageManager.editIncomes(incomes: incomeToEdit, newName: amountText, newNote: comments, newCategory: category, newAmount: amount, newDate: date)
            }
            
            // Вызываем замыкание и передаем информацию
            onSubmit?(amountText, category, dateText, comments)
            
            // Закрываем модальное окно
            dismiss(animated: true, completion: nil)
            
        } else {
            // Создание нового объекта Expense
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            let newIncome = Incomes()
            newIncome.amount = amount
            newIncome.category = category
            
            if let date = dateFormatter.date(from: dateText) { newIncome.date = date }
            
            newIncome.note = comments

            storageManager.create(newIncome) // Добавляем новый объект в базу данных Realm
            
            // Вызываем замыкание и передаем информацию
            onSubmit?(amountText, category, dateText, comments)
            
            // Закрываем модальное окно
            dismiss(animated: true, completion: nil)
        }
    }
}

extension AddIncomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { .none }
}

extension AddIncomeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension AddIncomeViewController {
    @objc func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let date = dateFormatter.date(from: dateTextField.text ?? "") { datePicker.date = date }
        
        let alertController = UIAlertController(title: "Выберите дату и время", message: nil, preferredStyle: .actionSheet)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        
        stackView.addArrangedSubview(datePicker)
        
        alertController.view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: alertController.view.centerYAnchor, constant: -20),
            alertController.view.heightAnchor.constraint(equalToConstant: 260)
        ])
        
        let doneAction = UIAlertAction(title: "Готово", style: .default) { _ in
            self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        }
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func doneButtonTapped() { dateTextField.resignFirstResponder() }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy HH:mm"
        dateTextField.text = formatter.string(from: sender.date)
    }
}

extension AddIncomeViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { view.endEditing(true) }
}

extension AddIncomeViewController {
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() { view.endEditing(true) }
    
    @objc func keyboardWillShowWithNotification(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if commentsTextField.isFirstResponder { view.frame.origin.y = -keyboardSize.height }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) { view.frame.origin.y = 0 }
}
