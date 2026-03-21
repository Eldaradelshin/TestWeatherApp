//
//  Constants.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 15.03.2026.
//

import Foundation

public struct Config {
    
    static let shared = Config()
    
    private init() {}
    
    let baseURL = "https://api.weatherapi.com/v1"
    let apiKey  = "fa8b3df74d4042b9aa7135114252304"
    let forecastDays: Int = 3
}
