//
//  HourlyForecastData.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 19.03.2026.
//

import Foundation

struct HourlyForecastData {
    let time: String
    let temperature: String
    let imaageUrl: String
    
    init(time: String, temperature: String, imaageUrl: String) {
        self.time = time
        self.temperature = temperature
        self.imaageUrl = imaageUrl
    }
}
