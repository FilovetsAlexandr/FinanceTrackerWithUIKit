//
//  AlertForExpensesVC.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 19.11.23.
//

import UIKit
import RealmSwift

class AddExpenseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let datePicker = UIDatePicker()

    var categories = ["Покупки", "Еда", "Развлечения", "Подарки", "Связь и интернет", "Путешествия"]


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

    let dateTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.inputView = UIDatePicker()
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
    }

    func setupUI() {
        dateTextField.addTarget(self, action: #selector(dateTextFieldTapped), for: .touchUpInside)
        // Установите экземпляр UIDatePicker в качестве inputView для dateTextField
            dateTextField.inputView = datePicker
            
            // Добавьте кнопку "Готово" на инструментальную панель UIDatePicker
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
            toolbar.setItems([doneButton], animated: false)
            dateTextField.inputAccessoryView = toolbar
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        addButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        
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

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { categories.count }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { categories[row] }

    // MARK: - Actions

    @objc func addCategory() {
        let alertController = UIAlertController(title: "Добавить категорию", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Название"
        }
        let addAction = UIAlertAction(title: "Добавить", style: .default) { _ in
            if let category = alertController.textFields?.first?.text {
                self.categories.append(category)
                self.categoryPicker.reloadAllComponents()
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.size.height
        
        let buttonMaxY = dateTextField.frame.maxY
        let visibleHeight = view.frame.size.height - keyboardHeight
        
        if buttonMaxY > visibleHeight {
            let offsetY = buttonMaxY - visibleHeight
            view.transform = CGAffineTransform(translationX: 0, y: -offsetY)
            view.transform = CGAffineTransform.identity
        }
    }
    @objc func dateTextFieldTapped() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 250))
        inputView.backgroundColor = .white
        inputView.addSubview(datePicker)

        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: inputView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: inputView.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: inputView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: inputView.bottomAnchor).isActive = true
        
        dateTextField.inputView = inputView
        dateTextField.inputAccessoryView = toolbar
        dateTextField.becomeFirstResponder()
    }
}
extension AddExpenseViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle { .none }
    }

extension AddExpenseViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        textField == dateTextField ? showDatePicker() : ()
        return textField != dateTextField
        }
    }

extension AddExpenseViewController {
    func showDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        dateTextField.delegate = self
    }
    
    @objc func doneButtonTapped() { dateTextField.resignFirstResponder() }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy HH:mm"
        dateTextField.text = formatter.string(from: sender.date)
    }
}
