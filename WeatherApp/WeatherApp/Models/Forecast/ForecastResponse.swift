//
//  Forecast.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 16.03.2026.
//

import Foundation

struct ForecastResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}
