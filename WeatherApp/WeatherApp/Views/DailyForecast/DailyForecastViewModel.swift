//
//  DailyForecastViewModel.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 20.03.2026.
//

import UIKit
import Combine

protocol DailyForecastViewModelProtocol: AnyObject, UITableViewDataSource, UITableViewDelegate {
    var dailyForecastData: [DailyForecastData] { get set }
}

final class DailyForecastViewModel: NSObject, DailyForecastViewModelProtocol {
    
    @Published var dailyForecastData: [DailyForecastData] = []
    
    var mockData: [DailyForecastData] = [
        DailyForecastData(day: "Today", condition: "Sunny", imageUrl: "", highTempC: "8°", lowTempC: "6°"),
        DailyForecastData(day: "Saturday", condition: "Cloudy", imageUrl: "", highTempC: "7°", lowTempC: "5°"),
        DailyForecastData(day: "Friday", condition: "Rainy", imageUrl: "", highTempC: "9°", lowTempC: "8°"),
    ]
}

extension DailyForecastViewModel: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayForecastCell.identifier, for: indexPath) as? DayForecastCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.configure(with: dailyForecastData[indexPath.row])
        return cell
    }
}


