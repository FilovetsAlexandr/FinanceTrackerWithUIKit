//
//  ExpensesViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 14.11.23.


import RealmSwift
import UIKit
import Lottie

final class ExpensesViewController: UITableViewController {

    private var addExpenseVC: AddExpenseViewController?
    private var filteredExpenses: [Expenses] = []
    private var expenseSections: [ExpenseSection] = []
    private var dateFormatter: DateFormatter!
    private var expenses: Results<Expenses>!
    private var animationView: LottieAnimationView!

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
    
    // Редактирование расхода
    
        override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Изменить") { [weak self] (_, _, completion) in
            self?.editExpense(at: indexPath)
            completion(true)
        }
        editAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    // Удаление расхода
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completion) in
            let expense = self?.expenseSections[indexPath.section].expenses[indexPath.row]
            
            let alert = UIAlertController(title: "Удаление", message: "Вы действительно хотите удалить?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in completion(false) }
            
            let deleteConfirmAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                StorageManager.shared.deleteExpense(expense: expense!)
                self?.update()
                completion(true) // Подтвердить удаление
            }
            
            alert.addAction(cancelAction)
            alert.addAction(deleteConfirmAction)
            
            self?.present(alert, animated: true, completion: nil)
        }
        
        deleteAction.backgroundColor = UIColor.red
        
        let swipeView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        swipeView.backgroundColor = .clear
        
        let animationView = LottieAnimationView(name: "trash2")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.frame = swipeView.bounds
        animationView.play()
        
        swipeView.addSubview(animationView)
        
        // Создаем анимацию из анимационного view
        let animation = LottieAnimation.named("trash2")
        let animationViewNew = LottieAnimationView(animation: animation)
        animationViewNew.frame = swipeView.bounds
        animationViewNew.contentMode = .scaleAspectFit
        animationViewNew.loopMode = .loop
        animationViewNew.play()
        
        // Создаем snapshot из анимационного view
        let snapshotView = UIView(frame: swipeView.bounds)
        snapshotView.addSubview(animationViewNew)
        let renderer = UIGraphicsImageRenderer(bounds: swipeView.bounds)
        let snapshotImage = renderer.image { _ in
            snapshotView.drawHierarchy(in: snapshotView.bounds, afterScreenUpdates: true)
        }
        
        deleteAction.image = snapshotImage
        
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < expenseSections.count else { return 0 }
        return expenseSections[section].expenses.count
    }

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
        addExpenseViewController.onExpenseAdded = { [weak self] in self?.update() }
        navigationController?.pushViewController(addExpenseViewController, animated: true)
    }
    
    private func editExpense(at indexPath: IndexPath) {
        // Получаем выбранный расход для редактирования
        let section = indexPath.section
        let row = indexPath.row
        let expenseToEdit = expenseSections[section].expenses[row]

        let editExpenseVC = AddExpenseViewController()
        editExpenseVC.expenseToEdit = expenseToEdit
        editExpenseVC.onExpenseAdded = { [weak self] in self?.update() }

        let navController = UINavigationController(rootViewController: editExpenseVC)
        present(navController, animated: true, completion: nil)
    }
    
    @objc private func addBarButtonSystemItemSelector() {
        let navController = UINavigationController(rootViewController: addExpenseVC!)
        present(navController, animated: true, completion: nil)
    }
    
     func update() {
        expenses = StorageManager.shared.getAllExpenses()
        filteredExpenses = Array(expenses)
        expenseSections = generateExpenseSections()
        tableView.reloadData()
    }
    
    private func handleExpenseAdded(_ expense: Expenses) {
        StorageManager.shared.saveExpenses(expenses: expense)
        expenseSections = generateExpenseSections()
        tableView.reloadData()
    }

    private func generateExpenseSections() -> [ExpenseSection] {
        var sections: [ExpenseSection] = []

        let groupedExpenses = Dictionary(grouping: filteredExpenses, by: { Calendar.current.startOfDay(for: $0.date) })
        let sortedKeys = groupedExpenses.keys.sorted(by: >)

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
        let storageManager = StorageManager.shared
        expenses = storageManager.getAllExpenses()
        filteredExpenses = Array(expenses)
        expenseSections = generateExpenseSections()
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }

    private func setupNavigationBar() {
        animationView = LottieAnimationView(name: "refresh")
        animationView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        animationView.contentMode = .scaleAspectFit

        let animationContainerView = UIView(frame: animationView.bounds)
        animationContainerView.addSubview(animationView)

        // Установите возможность взаимодействия для вашей картинки
        animationContainerView.isUserInteractionEnabled = true
        animationContainerView.translatesAutoresizingMaskIntoConstraints = true
        
        // Создайте жест нажатия
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animationViewTapped))
        
        // Добавьте жест нажатия на вашу картинку
        animationContainerView.addGestureRecognizer(tapGesture)

        
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        customView.addSubview(animationContainerView)

        let customBarButton = UIBarButtonItem(customView: customView)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonSystemItemSelector))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItems = [addButton, customBarButton]
        
    }
    
    @objc private func animationViewTapped() {
        animationView.play()
        update()
    }
    
    private func setupAddButton() {
        addExpenseVC = AddExpenseViewController()
        addExpenseVC?.onSubmit = { [weak self] amount, category, date, comments in
            // Обработка добавления расхода
            let expense = Expenses()
            expense.amount = Double(amount) ?? 0.0
            expense.category = category
            expense.date = self?.dateFormatter.date(from: date) ?? Date()
            expense.note = comments ?? ""
            // Обновление отображения
            self?.update()
        }
    }
}

extension ExpensesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty {
                filteredExpenses = Array(expenses)
            } else {
                filteredExpenses = expenses.filter { expense in expense.category?.name.lowercased().contains(searchText.lowercased()) ?? false }
            }
            expenseSections = generateExpenseSections()
            DispatchQueue.main.async { self.update() }
        }
    }
}
