//
//  ChartsViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 10.11.23.
//

//import Charts
import RealmSwift
import UIKit

class ChartsViewController: UIViewController {

//    var pieChart = PieChartView()
    var expenses: Results<Expenses>!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupUI()
//        setupPieChart()
//        loadData()
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        pieChart.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width)
//        pieChart.center = view.center
//    }
//    
//    private func setupUI() {
//        title = "Статистика"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        view.backgroundColor = .white
//    }
//    
//    private func setupPieChart() {
//        pieChart.delegate = self
//             view.addSubview(pieChart)
//             
//             pieChart.entryLabelFont = UIFont.systemFont(ofSize: 12)
//             pieChart.entryLabelColor = .black
//             pieChart.drawEntryLabelsEnabled = true
//             pieChart.legend.enabled = false
//        
//    }
//    
//    private func loadData() {
//        expenses = realm.objects(Expenses.self)
//        updateChartData()
//    }
//    
//    func updateChartData() {
//        let chartHeight = self.view.frame.height - (self.tabBarController?.tabBar.frame.height)!
//        let chart = PieChartView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: chartHeight))
//        
//        var categoryExpenses: [String: Double] = [:]
//        
//        // Здесь мы используем вашу базу данных для получения категорий и сумм
//        for expense in expenses {
//            if let categoryName = expense.category?.name {
//                if let currentAmount = categoryExpenses[categoryName] {
//                    categoryExpenses[categoryName] = currentAmount + expense.amount
//                    pieChart.notifyDataSetChanged()
//                } else {
//                    categoryExpenses[categoryName] = expense.amount
//                    pieChart.notifyDataSetChanged()
//                }
//            }
//        }
//        
//        var entries = [PieChartDataEntry]()
//        var colors = [UIColor]()
//        
//        // Генерируем случайные цвета для графика
//        for (category, amount) in categoryExpenses {
//            let entry = PieChartDataEntry(value: amount, label: category)
//            pieChart.notifyDataSetChanged()
//            entries.append(entry)
//            
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//            colors.append(color)
//        }
//        
//        let set = PieChartDataSet(entries: entries, label: "")
//        set.colors = colors
//        let data = PieChartData(dataSet: set)
//        chart.data = data
//        chart.noDataText = "No data available"
//        chart.isUserInteractionEnabled = true
//        
//        self.view.addSubview(chart)
//    }
}

//extension ChartsViewController: ChartViewDelegate {
//}
