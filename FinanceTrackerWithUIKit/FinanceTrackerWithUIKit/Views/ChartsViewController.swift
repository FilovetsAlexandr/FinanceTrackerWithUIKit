//
//  ChartsViewController.swift
//  FinanceTrackerWithUIKit
//
//  Created by Alexandr Filovets on 10.11.23.
//

import UIKit
import Charts
import DGCharts

class ChartsViewController: UIViewController {
    
    var pieChartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChartView = PieChartView(frame: view.bounds)
        view.addSubview(pieChartView)
           
        // Настройка данных для графика
        let entry1 = PieChartDataEntry(value: 30, label: "Расходы")
        let entry2 = PieChartDataEntry(value: 70, label: "Доходы")

        let dataSet = PieChartDataSet(entries: [entry1, entry2], label: "Финансы")
        let data = PieChartData(dataSet: dataSet)
        
        pieChartView.data = data
        // Обновление графика
        pieChartView.notifyDataSetChanged()
    }
    
    // ...
}
