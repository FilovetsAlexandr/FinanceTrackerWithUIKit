//
//  ExpensesViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 14.11.23.
//

import UIKit
import RealmSwift

class ExpensesListViewController: UITableViewController, UISearchResultsUpdating {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var filteredExpensesLists: [ExpensesList] = []
    
    var isFiltering: Bool { searchController.isActive && !isSearchBarEmpty }
    var isSearchBarEmpty: Bool { searchController.searchBar.text?.isEmpty ?? true }
    
    // Results - отображает данны в режиме реального времени
    var expensesLists: Results<ExpensesList>!
    
    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // выборка из DB + сортировка
        expensesLists = StorageManager.getAllExpensesList()
        addExpensesListObserver()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { isFiltering ? filteredExpensesLists.count : expensesLists.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
                let expensesList = isFiltering ? filteredExpensesLists[indexPath.row] : expensesLists[indexPath.row]
                // Настройка ячейки с учетом отфильтрованных результатов
                return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentList = expensesLists[indexPath.row]
        
        let deleteContextualAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, _ in
            StorageManager.deleteExpensesList(expensesList: currentList)
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editContextualAction = UIContextualAction(style: .destructive, title: "Edit") { [weak self] _, _, _ in
            self?.alertForAddAndUpdatesListTasks(currentList: currentList, indexPath: indexPath)
        }
        
        deleteContextualAction.backgroundColor = .red
        editContextualAction.backgroundColor = .green
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [editContextualAction, deleteContextualAction])
        
        return swipeActionsConfiguration
    }
    
    @objc
    private func addBarButtonSystemItemSelector() {
        let alertController = UIAlertController(title: "Добавить расход", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField: UITextField!) in
            textField.placeholder = "Сумма"
        }

        alertController.addTextField { (textField: UITextField!) in
            textField.placeholder = "Категория"
        }

        // Добавьте другие текстовые поля для даты, времени и комментария

        let saveAction = UIAlertAction(title: "Сохранить", style: .default, handler: { alert -> Void in
            // Извлеките значения из текстовых полей и сохраните их
        })

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil) // Добавьте эту строку
    }
    
    private func alertForAddAndUpdatesListTasks(currentList: ExpensesList? = nil, indexPath: IndexPath? = nil) {
        
        let title = currentList == nil ? "New list" : "Edit List"
        let messege = "Please insert list name"
        let doneButtonName = currentList == nil ? "Save" : "Update"
        
        let alertController = UIAlertController(title: title, message: messege, preferredStyle: .alert)
        
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButtonName, style: .default) { [weak self] _ in
            guard let self,
                  let newListName = alertTextField.text,
                  !newListName.isEmpty else { return }

            if let currentList = currentList,
               let indexPath = indexPath {
                StorageManager.editExpensesList(expensesList: currentList, newListName: newListName)
                self.tableView.reloadRows(at: [indexPath], with: .automatic) // Reload the specific row
            } else {
                let expensesList = ExpensesList()
                expensesList.name = newListName
                StorageManager.saveExpensesList(expensesList: expensesList)
                self.tableView.reloadData() // Reload the entire table view
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        alertController.addTextField { textField in
            alertTextField = textField
            alertTextField.text = currentList?.name
            alertTextField.placeholder = "List name"
        }
        
        present(alertController, animated: true)
    }
    
    private func addExpensesListObserver() {
        notificationToken = expensesLists.observe({ [weak self] changes in
            guard let self else { return }
            switch changes {
                case .initial:
                    // Results are now populated and can be accessed without blocking the UI
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
        })
    }
    func updateSearchResults(for searchController: UISearchController) {
          if let searchText = searchController.searchBar.text {
              filteredExpensesLists = expensesLists.filter { $0.name.lowercased().contains(searchText.lowercased()) }
              tableView.reloadData()
          }
      }
    
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
}
