//
//  SectionHeaderView.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 28.11.23.
//

import UIKit

final class SectionHeaderView: UITableViewHeaderFooterView {
    
    let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Настройка внешнего вида заголовка секции
        contentView.backgroundColor = .white
        
        // Настройка внешнего вида titleLabel
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(24)
        titleLabel.textColor = .black
        
        // Добавление titleLabel в contentView
        contentView.addSubview(titleLabel)
        
        // Настройка ограничений для titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
