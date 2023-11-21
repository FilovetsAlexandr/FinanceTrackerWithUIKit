//
//  ExpensesViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 14.11.23.
//

import RealmSwift
import UIKit

class ExpensesViewController: UITableViewController, UISearchResultsUpdating {
    var addExpenseVC: AddExpenseViewController?
    let searchController = UISearchController(searchResultsController: nil)

    var filteredExpenses: [Expenses] = []

    var isFiltering: Bool { searchController.isActive && !isSearchBarEmpty }
    var isSearchBarEmpty: Bool { searchController.searchBar.text?.isEmpty ?? true }

    // Results - отображает данны в режиме реального времени
    var expenses: Results<Expenses>!

    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // выборка из DB + сортировка
        expenses = StorageManager.getAllExpenses()
        addExpenseVC = AddExpenseViewController()
        // Установка замыкания для получения данных
//        addExpenseVC?.onExpenseAdded = { [weak self] expense in
//        // Сохранение объекта Expense в RealmSwift
//        StorageManager.saveExpenses(expenses: expense)
//        // Обновление данных в таблице
//        self?.tableView.reloadData()
//        }
        addExpensesListObserver()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { isFiltering ? filteredExpenses.count : expenses.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let expenses = isFiltering ? filteredExpenses[indexPath.row] : expenses[indexPath.row]
        cell.textLabel?.text = expenses.category
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }

    @objc private func addBarButtonSystemItemSelector() {
        let navController = UINavigationController(rootViewController: addExpenseVC!)
        present(navController, animated: true, completion: nil)
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredExpenses = expenses.filter { $0.category.lowercased().contains(searchText.lowercased()) }
            tableView.reloadData()
        }
    }

    // MARK: - Private methods

    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск расходов"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func setupUI() {
        title = "Расходы"
        navigationController?.navigationBar.prefersLargeTitles = true
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        navigationItem.setRightBarButton(add, animated: true)
    }

    private func addExpensesListObserver() {
        notificationToken = expenses.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
                case .initial:
                    print("= = = initial case")
                case .update(_, let deletions, let insertions, let modifications):
                    print("= = = deletions: \(deletions)")
                    print("= = = insertions: \(insertions)")
                    print("= = = modifications: \(modifications)")

                    // Query results have changed, so apply them to the UITableView
                    tableView.performBatchUpdates({
                        // Always apply updates in the following order: deletions, insertions, then modifications.
                        // Handling insertions before deletions may result in unexpected behavior.
                        self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                                  with: .automatic)
                        self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                                  with: .automatic)
                        self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) },
                                                  with: .automatic)
                    }, completion: { _ in })
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    fatalError("\(error)")
            }
        }
    }
}
