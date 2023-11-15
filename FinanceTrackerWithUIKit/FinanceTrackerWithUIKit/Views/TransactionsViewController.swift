//
//  TransactionsViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 10.11.23.
//

import RealmSwift
import UIKit

class TransactionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var transactions: Results<TransactionRealm>!
    var tableView: UITableView!
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
           // Другие настройки вашего контроллера
//         Создай Navigation Bar
          let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
          
          // Создай Navigation Item
          let navigationItem = UINavigationItem(title: "Заголовок")
          
          // Добавь Navigation Item в Navigation Bar
          navigationBar.items = [navigationItem]
          
          // Добавь Navigation Bar на view
          view.addSubview(navigationBar)
        view.backgroundColor = .white
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
//        let navigationItem = UINavigationItem(title: "Transactions")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTransaction))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.items = [navigationItem]
        
        
        loadTransactions()
        
        notificationToken = transactions.observe { [weak self] changes in
            guard let self = self else { return }
            
            switch changes {
            case .initial:
               self.tableView.reloadData()
                print("Failed to observe transactions")
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
            case .error(let error):
                print("Failed to observe transactions: \(error)")
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }

    func loadTransactions() {
        transactions = DataManager.shared.loadTransactions()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let transaction = transactions[indexPath.row]
        cell.textLabel?.text = "\(transaction.amount) - \(transaction.category)"
        return cell
    }

    @objc func addTransaction() {
        let alertController = UIAlertController(title: "Добавить транзакцию", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Сумма"
            textField.keyboardType = .decimalPad
        }
        alertController.addTextField { textField in
            textField.placeholder = "Категория"
        }
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            guard let self = self,
                  let amountText = alertController.textFields?.first?.text,
                  let category = alertController.textFields?.last?.text,
                  let amount = Double(amountText)
            else { return }
            
            let transaction = TransactionRealm()
            transaction.amount = amount
            transaction.category = category
            
            DataManager.shared.saveTransaction(amount: transaction.amount, type: transaction.type, category: transaction.category, date: transaction.date)
            
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

}
