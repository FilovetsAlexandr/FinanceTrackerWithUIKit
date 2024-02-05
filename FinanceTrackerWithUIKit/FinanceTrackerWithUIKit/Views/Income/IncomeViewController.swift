//
//  IncomeViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 14.11.23.
//

import Lottie
import RealmSwift
import UIKit

final class IncomeViewController: UITableViewController {
    private var addIncomeVC: AddIncomeViewController?
    private var filteredIncomes: [Incomes] = []
    private var incomeSections: [IncomeSection] = []
    private var dateFormatter: DateFormatter!
    private var incomes: Results<Incomes>!
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

    // Подробная информация

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let income = incomeSections[indexPath.section].incomes[indexPath.row]
        let detailVC = IncomeDetailViewController(income: income)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // Редактирование расхода

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Изменить") { [weak self] _, _, completion in
            self?.editIncome(at: indexPath)
            completion(true)
        }
        editAction.backgroundColor = .gray
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    // Удаление расхода

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] _, _, completion in
            let income = self?.incomeSections[indexPath.section].incomes[indexPath.row]

            let alert = UIAlertController(title: "Удаление", message: "Вы действительно хотите удалить?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { _ in completion(false) }

            let deleteConfirmAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                StorageManager.shared.deleteIncome(income: income!)
                self?.update()
                completion(true) // Подтвердить удаление
            }

            alert.addAction(cancelAction)
            alert.addAction(deleteConfirmAction)

            self?.present(alert, animated: true, completion: nil)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = SectionHeaderView(reuseIdentifier: "SectionHeader")
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from: incomeSections[section].date)
        headerView.titleLabel.text = dateString
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 45 }

    override func numberOfSections(in tableView: UITableView) -> Int { incomeSections.count }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < incomeSections.count else { return 0 }
        return incomeSections[section].incomes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IncomeTableViewCell(style: .default, reuseIdentifier: "Cell")
        let income = incomeSections[indexPath.section].incomes[indexPath.row]
        let amountString = income.amount.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", income.amount) : String(format: "%.2f", income.amount)

        dateFormatter.timeStyle = .short

        guard indexPath.section < incomeSections.count, indexPath.row < incomeSections[indexPath.section].incomes.count else { return cell }

        cell.categoryLabel.text = income.category?.name
        cell.photoImageView.image = UIImage(named: income.category?.imageName ?? "")
        cell.timeLabel.text = dateFormatter.string(from: income.date)
        cell.amountLabel.text = amountString + " BYN"

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool { true }

    // MARK: - Private methods

    private func showAddIncomeViewController(with income: Incomes) {
        let addIncomeViewController = AddIncomeViewController()
        addIncomeViewController.incomeToEdit = income
        addIncomeViewController.isEditing = true
        addIncomeViewController.onIncomeAdded = { [weak self] in self?.update() }
        navigationController?.pushViewController(addIncomeViewController, animated: true)
    }

    private func editIncome(at indexPath: IndexPath) {
        // Получаем выбранный доход для редактирования
        let section = indexPath.section
        let row = indexPath.row
        let incomeToEdit = incomeSections[section].incomes[row]

        let editIncomeVC = AddIncomeViewController()
        editIncomeVC.incomeToEdit = incomeToEdit
        editIncomeVC.onIncomeAdded = { [weak self] in self?.update() }

        let navController = UINavigationController(rootViewController: editIncomeVC)
        present(navController, animated: true, completion: nil)
    }

    @objc private func addBarButtonSystemItemSelector() {
        let navController = UINavigationController(rootViewController: addIncomeVC!)
        present(navController, animated: true, completion: nil)
    }

    private func update() {
        incomes = StorageManager.shared.getAllIncomes()
        filteredIncomes = Array(incomes)
        incomeSections = generateIncomeSections()
        tableView.reloadData()
    }

    private func handleExpenseAdded(_ income: Incomes) {
        StorageManager.shared.saveIncomes(incomes: income)
        incomeSections = generateIncomeSections()
        tableView.reloadData()
    }

    private func generateIncomeSections() -> [IncomeSection] {
        var sections: [IncomeSection] = []

        let groupedIncomes = Dictionary(grouping: filteredIncomes, by: { Calendar.current.startOfDay(for: $0.date) })
        let sortedKeys = groupedIncomes.keys.sorted(by: >)

        for key in sortedKeys {
            if let incomes = groupedIncomes[key] {
                let sortedIncomes = incomes.sorted(by: { $0.date > $1.date })
                let section = IncomeSection(date: key, incomes: sortedIncomes)
                sections.append(section)
            }
        }
        return sections
    }

    private func setupUI() {
        title = "Доходы"
        navigationController?.navigationBar.prefersLargeTitles = true
        definesPresentationContext = true
        dateFormatter = DateFormatter()
    }

    private func loadData() {
        let storageManager = StorageManager.shared
        incomes = storageManager.getAllIncomes()
        filteredIncomes = Array(incomes)
        incomeSections = generateIncomeSections()
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
        addIncomeVC = AddIncomeViewController()
        addIncomeVC?.onSubmit = { [weak self] amount, category, date, comments in
            // Обработка добавления расхода
            let income = Incomes()
            income.amount = Double(amount) ?? 0.0
            income.category = category
            income.date = self?.dateFormatter.date(from: date) ?? Date()
            income.note = comments ?? ""
            // Обновление отображения
            self?.update()
        }
    }
}

extension IncomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            if searchText.isEmpty {
                filteredIncomes = Array(incomes)
            } else {
                filteredIncomes = incomes.filter { income in income.category?.name.lowercased().contains(searchText.lowercased()) ?? false }
            }
            incomeSections = generateIncomeSections()
            tableView.reloadData()
        }
    }
}
