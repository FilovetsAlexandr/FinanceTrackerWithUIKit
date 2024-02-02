//
//  ChartsViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 10.11.23.
//

import Charts
import DGCharts
import RealmSwift
import UIKit

final class ChartsViewController: UIViewController, ChartViewDelegate {
    private var expenses = StorageManager.shared.getAllExpenses()
    private var pieChartView = PieChartView()
    private var dataEntries: [PieChartDataEntry] = []
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPieChart()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Запускаем анимацию графика
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupPieChart() {
        pieChartView = PieChartView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        // Включаем легенду
        pieChartView.legend.enabled = true
        
        // Устанавливаем позицию легенды
        pieChartView.legend.horizontalAlignment = .left
        pieChartView.legend.verticalAlignment = .bottom
        pieChartView.legend.orientation = .vertical
        pieChartView.legend.xEntrySpace = 5
        pieChartView.legend.yEntrySpace = 0
        pieChartView.legend.yOffset = 50
        
        pieChartView.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: pieChartView.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: pieChartView.centerYAnchor)
        ])
        
        var categoryExpenses: [String: Double] = [:]
        
        // Подсчитываем сумму расходов по категориям
        for expense in expenses {
            let categoryName = expense.category?.name ?? "No Category"
            
            if let currentAmount = categoryExpenses[categoryName] {
                categoryExpenses[categoryName] = currentAmount + expense.amount
            } else {
                categoryExpenses[categoryName] = expense.amount
            }
        }
        // Создаем массив данных для PieChart графика
        dataEntries = []
        for (categoryName, amount) in categoryExpenses {
            let dataEntry = PieChartDataEntry(value: amount, label: categoryName)
            dataEntries.append(dataEntry)
        }
        
        // Создаем случайные цвета
        var randomColors: [UIColor] = []
        for _ in 0 ..< dataEntries.count {
            let randomColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1)
            randomColors.append(randomColor)
        }
        
        // Создаем dataSet с уникальными цветами для всех записей данных
        var dataSets: [PieChartDataSet] = []
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.drawValuesEnabled = false // Отключаем отображение значений на графике
        pieChartView.drawEntryLabelsEnabled = false // Устанавливаем, что имена категорий не будут отображаться на графике
        for (index, _) in dataEntries.enumerated() {
            let randomColor = randomColors[index % randomColors.count]
            dataSet.colors.append(randomColor)
        }
        dataSets.append(dataSet)
        
        let data = PieChartData(dataSets: dataSets)
        pieChartView.data = data
        
        // Добавляем обработчик нажатия на сегменты пирога
        pieChartView.delegate = self
        self.view.addSubview(pieChartView)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let pieChartView = chartView as? PieChartView else { return }

        let dataSetIndex = highlight.dataSetIndex // Индекс dataSet сегмента пирога
        let dataSet = pieChartView.data?.dataSets[dataSetIndex]

        if let dataEntryIndex = dataSet?.entryIndex(entry: entry) {
            let dataEntry = dataEntries[dataEntryIndex]
            let category = dataEntry.label ?? "No Category"

            let amount = entry.y

            let totalAmount = expenses.reduce(0) { $0 + $1.amount }

            let percentage: Double
            if totalAmount == 0 {
                percentage = 0.0
            } else {
                percentage = (amount / totalAmount) * 100
            }

            let clampedPercentage = min(percentage, 100)
               
            let formattedPercentage = String(format: "%.1f", clampedPercentage)
            let formattedAmount = String(format: "%.0f", amount)

            infoLabel.text =
                """
                    Категория: \(category)
                    Расход: \(formattedAmount) BYN
                    Процент трат: \(formattedPercentage)%
                """
        }
    }
}
