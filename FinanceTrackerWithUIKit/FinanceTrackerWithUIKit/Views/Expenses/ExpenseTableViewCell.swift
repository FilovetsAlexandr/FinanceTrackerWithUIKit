//
//  ExpenseTableViewCell.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 28.11.23.
//

import UIKit

final class ExpenseTableViewCell: UITableViewCell {
    
    let categoryLabel = UILabel()
    let amountLabel = UILabel()
    let timeLabel = UILabel()
    let photoImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        // Отключение автоматического изменения размера маски элементов
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавление элементов к contentView ячейки
        contentView.addSubview(photoImageView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(timeLabel)
        
        // Определение ограничений для каждого элемента
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photoImageView.widthAnchor.constraint(equalToConstant: 75),  // Задание ширины UIImageView
            photoImageView.heightAnchor.constraint(equalToConstant: 75),  // Задание высоты UIImageView
            
            categoryLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            
            amountLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            amountLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 5),
            
            timeLabel.leadingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timeLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 5),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
