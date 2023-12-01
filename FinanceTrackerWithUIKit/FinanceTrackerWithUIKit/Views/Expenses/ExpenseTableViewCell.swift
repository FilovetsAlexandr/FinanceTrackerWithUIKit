//
//  ExpenseTableViewCell.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 28.11.23.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {
    let categoryLabel = UILabel()
    let amountLabel = UILabel()
    let timeLabel = UILabel()
    let photoImageView = UIImageView()  // Добавление UIImageView для фотографии

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Настройка внешнего вида ячейки и добавление элементов интерфейса пользователя
        
        // Отключение автоматического изменения размера маски элементов
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.translatesAutoresizingMaskIntoConstraints = false  // Отключение автоматического изменения размера маски UIImageView
        
        // Добавление элементов к contentView ячейки
        contentView.addSubview(photoImageView)  // Добавление UIImageView в contentView ячейки
        contentView.addSubview(categoryLabel)
        contentView.addSubview(amountLabel)
        contentView.addSubview(timeLabel)
        
        // Определение ограничений для каждого элемента
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            photoImageView.widthAnchor.constraint(equalToConstant: 50),  // Задание ширины UIImageView
            photoImageView.heightAnchor.constraint(equalToConstant: 50),  // Задание высоты UIImageView
            
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
