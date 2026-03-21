//
//  CurrentWeatherResponse.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 15.03.2026.
//

import Foundation

struct CurrentWeatherResponse: Codable {
    let location: Location
    let current: Current
    
    
    private enum CodingKeys: String, CodingKey {
        case location
        case current
    }
}
