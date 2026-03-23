//
//  Forecast.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 16.03.2026.
//

import Foundation

struct Forecast: Codable {
    let forecastdays: [ForecastDay]
    
    private enum CodingKeys: String, CodingKey {
        case forecastdays = "forecastday"
    }
}
