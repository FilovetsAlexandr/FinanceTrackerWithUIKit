//
//  AlertForExpensesVC.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 19.11.23.
//

import UIKit
import RealmSwift

class AddExpenseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var onSubmit: ((String, Category, String, String?) -> Void)?
    var onExpenseAdded: (() -> Void)?
    var selectedCategory: String?
    
    let datePicker = UIDatePicker()
    var categoryImages = [
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
        "Азартные игры": "casino"
    ]

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавить расход"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let amountLabel: UILabel = {
        let label = UILabel()
        label.text = "Сумма"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата и время"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "calendar"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let dateTextField: UITextField = {
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

    let commentsLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарии"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let commentsTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        submitButton.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
    }

    func setupUI() {

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
//        addButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        
//        view.addSubview(dateLabel)
        view.addSubview(dateButton)
        view.addSubview(dateTextField)
        
        
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

        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.centerYAnchor.constraint(equalTo: categoryLabel.centerYAnchor),
            addButton.leadingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: 8)
        ])
        
        view.addSubview(categoryPicker)
        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        view.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 16),
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
        
        view.addSubview(commentsLabel)
        NSLayoutConstraint.activate([
            commentsLabel.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 16),
            commentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        view.addSubview(commentsTextField)
        NSLayoutConstraint.activate([
            commentsTextField.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor, constant: 8),
            commentsTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            commentsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        let buttonStackView = UIStackView(arrangedSubviews: [cancelButton, submitButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: commentsTextField.bottomAnchor, constant: 16),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - UIPickerViewDelegate and UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { categoryImages.keys.count }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let category = Array(categoryImages.keys)[row]
        return category
    }

    // MARK: - Actions

//    @objc func addCategory() {
//        let alertController = UIAlertController(title: "Добавить категорию", message: nil, preferredStyle: .alert)
//        alertController.addTextField { textField in
//            textField.placeholder = "Название"
//        }
//        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
//            if let category = alertController.textFields?.first?.text {
//                self.categoryImages.append(category)
//                self.categoryPicker.reloadAllComponents()
//            }
//        }
//        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
//        alertController.addAction(addAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
    @objc func keyboardWillShow(notification: Notification) {
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
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = Array(categoryImages.keys)[row]
    }
    @objc func submitButtonPressed() {
        // Получаем информацию из текстовых полей
        let amount = amountTextField.text ?? ""
        let category = selectedCategory ?? ""
        let date = dateTextField.text ?? ""
        let comments = commentsTextField.text
        
        let newCategory = Category()
        newCategory.name = category
        newCategory.imageName = categoryImages[category]
        
        // Вызываем замыкание и передаем информацию
        onSubmit?(amount, newCategory, date, comments)

        // Закрываем модальное окно
        dismiss(animated: true, completion: nil)
      }
}
extension AddExpenseViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { .none }
    }

extension AddExpenseViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}

extension AddExpenseViewController {
    @objc func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        if let date = dateFormatter.date(from: dateTextField.text ?? "") {
            datePicker.date = date
        }
        
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
