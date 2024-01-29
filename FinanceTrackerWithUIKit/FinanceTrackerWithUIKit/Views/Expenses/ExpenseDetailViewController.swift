//
//  ExpenseDetailViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 29.01.24.
//

import UIKit

class ExpenseDetailViewController: UIViewController {

    private let expense: Expenses

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        return label
    }()

    init(expense: Expenses) {
        self.expense = expense
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        populateData()
    }

    private func setupUI() {
        title = "Подробности"
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(nameLabel)
        view.addSubview(noteLabel)
        view.addSubview(dateLabel)
        view.addSubview(amountLabel)
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false

        let margin: CGFloat = 16

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: margin),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: margin),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),

            noteLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: margin),
            noteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            noteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),

            dateLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: margin),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin),

            amountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: margin),
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin),
            amountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin)
        ])
    }

    private func populateData() {
        imageView.image = UIImage(named: expense.category?.imageName ?? "")
        nameLabel.text = expense.category?.name
        noteLabel.text = expense.note

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:MM"
        dateLabel.text = dateFormatter.string(from: expense.date)

        let amountString = expense.amount.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", expense.amount) : String(format: "%.2f", expense.amount)
        amountLabel.text = amountString + " BYN"
    }

}
