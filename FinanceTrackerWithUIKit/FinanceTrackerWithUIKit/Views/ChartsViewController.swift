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

class ChartsViewController: UIViewController {

    var pieChart = PieChartView()
    var expenses: Results<Expenses>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupPieChart()
        loadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pieChart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
        pieChart.center = view.center
    }
    
    private func setupUI() {
        title = "Статистика"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
    }
    
    private func setupPieChart() {
        pieChart.delegate = self
        view.addSubview(pieChart)
        
    }
    
    private func loadData() {
        expenses = realm.objects(Expenses.self)
        updatePieChart()
    }
    
    private func updatePieChart() {
        var entries = [PieChartDataEntry]()
        var totalAmount: Double = 0.0
        
        var categoryAmounts = [String: Double]()
        
        for expense in expenses {
            if let categoryName = expense.category?.name {
                totalAmount += expense.amount
                
                if let currentAmount = categoryAmounts[categoryName] {
                    categoryAmounts[categoryName] = currentAmount + expense.amount
                } else {
                    categoryAmounts[categoryName] = expense.amount
                }
            }
        }
        
        for (category, amount) in categoryAmounts {
            let percent = (amount / totalAmount) * 100.0
            let entry = PieChartDataEntry(value: percent, label: category)
            entries.append(entry)
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        dataSet.colors = ChartColorTemplates.joyful()
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
    }
}

extension ChartsViewController: ChartViewDelegate {
    // Реализация методов делегата графика PieChart
}
