//
//  WeatherForecastData.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 20.03.2026.
//

import Foundation

struct WeatherForecastData {
    let isDay: Bool
    let currentWeatherData: CurrentWeatherData
    let dailyForecastData: [DailyForecastData]
    let hourlyForecastData: [HourlyForecastData]
}
