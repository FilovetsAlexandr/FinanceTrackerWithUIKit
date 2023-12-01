//
//  ExpensesViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 14.11.23.
//

import RealmSwift
import UIKit

struct ExpenseSection {
    let date: Date
    let expenses: [Expenses]
}

class ExpensesViewController: UITableViewController, UISearchResultsUpdating {
    var addExpenseVC: AddExpenseViewController?

    var filteredExpenses: [Expenses] = []
    var expenseSections: [ExpenseSection] = []
    var dateFormatter: DateFormatter!

    // Results - отображает данны в режиме реального времени
    var expenses: Results<Expenses>!

    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // выборка из DB + сортировка
        let storageManager = StorageManager.shared
        expenses = storageManager.getAllExpenses()
        addExpenseVC = AddExpenseViewController()
        
        dateFormatter = DateFormatter()
        
        filteredExpenses = Array(expenses)
        expenseSections = generateExpenseSections()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView(reuseIdentifier: "SectionHeader")
    
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let dateString = dateFormatter.string(from: expenseSections[section].date)
        headerView.titleLabel.text = dateString
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 45 }

    override func numberOfSections(in tableView: UITableView) -> Int { expenseSections.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < expenseSections.count else {
            return 0
        }
        return expenseSections[section].expenses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExpenseTableViewCell(style: .default, reuseIdentifier: "Cell")
        
        guard indexPath.section < expenseSections.count, indexPath.row < expenseSections[indexPath.section].expenses.count else {
            return cell
        }

        let expense = expenseSections[indexPath.section].expenses[indexPath.row]

        dateFormatter.timeStyle = .short

        cell.categoryLabel.text = expense.category
        
        let amountString = expense.amount.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", expense.amount) : String(format: "%.2f", expense.amount)
        
        cell.amountLabel.text = amountString + " BYN"
        cell.timeLabel.text = dateFormatter.string(from: expense.date)
        cell.photoImageView.image = UIImage(named: "product")
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }

    @objc private func addBarButtonSystemItemSelector() {
        let navController = UINavigationController(rootViewController: addExpenseVC!)
        present(navController, animated: true, completion: nil)
    }

    @objc func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchController.searchBar.text?.isEmpty == true {
                filteredExpenses = Array(expenses)
            } else {
                filteredExpenses = Array(expenses.filter { $0.category.lowercased().contains(searchText.lowercased()) })
            }
            expenseSections = generateExpenseSections()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Private methods

    private func setupUI() {
        title = "Расходы"
        navigationController?.navigationBar.prefersLargeTitles = true
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        navigationItem.setRightBarButton(add, animated: true)
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func generateExpenseSections() -> [ExpenseSection] {
        var sections: [ExpenseSection] = []

        let groupedExpenses = Dictionary(grouping: filteredExpenses, by: { Calendar.current.startOfDay(for: $0.date) })
        let sortedKeys = groupedExpenses.keys.sorted(by: >)

        for key in sortedKeys {
            if let expenses = groupedExpenses[key] {
                let section = ExpenseSection(date: key, expenses: expenses)
                sections.append(section)
            }
        }

        return sections
    }
}
