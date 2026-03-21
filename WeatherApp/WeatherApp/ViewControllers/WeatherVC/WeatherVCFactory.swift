//
//  WeatherVCFactory.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 20.03.2026.
//

import UIKit

final class WeatherVCFactory {
    static func make() -> WeatherViewController {
        let config = Config.shared
        let requestFactory = WeatherRequestFactory(with: config)
        let networkService = NetworkService(weatherRequestFactory: requestFactory, config: config)
        
        let hourlyViewModel = HourlyForecastViewModel()
        let dailyViewModel = DailyForecastViewModel()
        let dataProvider = DataProvider()
        let weatherViewModel = WeatherViewModel(networkService: networkService,
                                                hourlyForecastViewModel: hourlyViewModel,
                                                dailyForecastViewModel: dailyViewModel,
                                                dataProvider: dataProvider)
        
        let weatherViewController = WeatherViewController(viewModel: weatherViewModel)
        
        return weatherViewController
    }
}
