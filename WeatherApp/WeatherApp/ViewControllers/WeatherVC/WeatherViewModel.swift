//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 18.03.2026.
//

import Foundation
import Combine

@MainActor
final class WeatherViewModel {
    
    // MARK: - Properties
    
    let hourlyForecastViewModel: HourlyForecastViewModel
    let dailyForecastViewModel: DailyForecastViewModel
    
    private let networkService: NetworkServiceProtocol
    private let dataProvider: DataProviderProtocol
    
    // MARK: - Published properties
    
    @Published var weatherData : WeatherForecastData?
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol,
         hourlyForecastViewModel: HourlyForecastViewModel,
         dailyForecastViewModel: DailyForecastViewModel,
         dataProvider: DataProviderProtocol) {
        self.networkService = networkService
        self.hourlyForecastViewModel = hourlyForecastViewModel
        self.dailyForecastViewModel = dailyForecastViewModel
        self.dataProvider = dataProvider
    }
    
    // MARK: - Methods
    
    func getForecast() async throws {
        let forecastResponse = try await networkService.getForecast()
        
        let weatherData = dataProvider.getData(from: forecastResponse)
        self.weatherData = weatherData
        self.dailyForecastViewModel.dailyForecastData  = weatherData.dailyForecastData
        self.hourlyForecastViewModel.hourlyForecastData = weatherData.hourlyForecastData
    }
    
   
}
