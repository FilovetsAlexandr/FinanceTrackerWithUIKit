//
//  ExpensesVC.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 23.01.24.
//

import RealmSwift
import UIKit
import Realm

final class ExpensesVC: UITableViewController {

    private var expenses: Results<Expenses>!
    private var filteredExpenses: Array<Expenses>?
    private var expenseSections: [ExpenseSection] = []
    private var dateFormatter: DateFormatter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupTableView()
        setupSearchController()
        setupNavigationBar()
        setupAddButton()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedExpense = expenseSections[indexPath.section].expenses[indexPath.row]
        showAddExpenseViewController(with: selectedExpense)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (_, _, completion) in
            let expense = self?.expenseSections[indexPath.section].expenses[indexPath.row]
            StorageManager.shared.deleteExpense(expense: expense!)
            self?.update()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView(reuseIdentifier: "SectionHeader")
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: expenseSections[section].date)
        headerView.titleLabel.text = dateString
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 45 }

    override func numberOfSections(in tableView: UITableView) -> Int { expenseSections.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { expenseSections[section].expenses.count  }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ExpenseTableViewCell(style: .default, reuseIdentifier: "Cell")
            let expense = expenseSections[indexPath.section].expenses[indexPath.row]
            let amountString = expense.amount.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", expense.amount) : String(format: "%.2f", expense.amount)
    
            dateFormatter.timeStyle = .short
    
            guard indexPath.section < expenseSections.count, indexPath.row < expenseSections[indexPath.section].expenses.count else { return cell }
    
            cell.categoryLabel.text = expense.category?.name
            cell.photoImageView.image = UIImage(named: expense.category?.imageName ?? "")
            cell.timeLabel.text = dateFormatter.string(from: expense.date)
            cell.amountLabel.text = amountString + " BYN"
    
            return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }

    // MARK: - Private methods

    private func showAddExpenseViewController(with expense: Expenses) {
        let addExpenseViewController = AddExpenseViewController()
        addExpenseViewController.expenseToEdit = expense
        addExpenseViewController.isEditing = true
        addExpenseViewController.onExpenseAdded = { [weak self] in
            self?.update()
        }
        navigationController?.pushViewController(addExpenseViewController, animated: true)
    }

    private func update() {
        expenseSections = generateExpenseSections()
        tableView.reloadData()
    }

    private func generateExpenseSections() -> [ExpenseSection] {
        let expensesToUse: Results<Expenses> // Создайте временную переменную для использования внутри метода
        if let filteredExpenses = filteredExpenses {
            let list = List<Expenses>()
            list.append(objectsIn: filteredExpenses)
            expensesToUse = list.sorted(byKeyPath: "date") // Сортировка списка по полю "date"
        } else {
            expensesToUse = expenses // Иначе используйте исходные расходы
        }

          let groupedExpenses = Dictionary(grouping: expensesToUse, by: { Calendar.current.startOfDay(for: $0.date) })
          let sortedKeys = groupedExpenses.keys.sorted(by: >)
          var sections: [ExpenseSection] = []
          for key in sortedKeys {
              if let expenses = groupedExpenses[key] {
                  let sortedExpenses = expenses.sorted(by: { $0.date > $1.date })
                  let section = ExpenseSection(date: key, expenses: sortedExpenses)
                  sections.append(section)
              }
          }
          return sections
      }

    private func setupUI() {
        title = "Расходы"
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
        dateFormatter = DateFormatter()
    }

    private func loadData() {
        expenses = StorageManager.shared.getAllExpenses()
        expenseSections = generateExpenseSections()
    }

    private func setupTableView() {
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
        tableView.register(ExpenseTableViewCell.self, forCellReuseIdentifier: "ExpenseTableViewCell")
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
}

extension ExpensesVC: UISearchResultsUpdating {
        func updateSearchResults(for searchController: UISearchController) {
            if let searchText = searchController.searchBar.text {
                if searchText.isEmpty {
                    filteredExpenses = Array(expenses)
                } else {
                    filteredExpenses = expenses.filter { expense in
                        expense.category?.name.lowercased().contains(searchText.lowercased()) ?? false
                    }
                }
                expenseSections = generateExpenseSections()
                DispatchQueue.main.async { self.tableView.reloadData() }
            }
        }
}
extension ExpensesVC: UISearchBarDelegate {
     func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         filteredExpenses = nil
         expenseSections = generateExpenseSections()
         tableView.reloadData()
     }
 }

extension ExpensesVC {
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }

    private func setupAddButton() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func addButtonPressed() {
        let addExpenseViewController = AddExpenseViewController()
        addExpenseViewController.onExpenseAdded = { [weak self] in
            self?.update()
        }
        navigationController?.pushViewController(addExpenseViewController, animated: true)
    }
}
