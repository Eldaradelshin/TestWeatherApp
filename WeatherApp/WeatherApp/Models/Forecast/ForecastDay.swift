//
//  Day.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 16.03.2026.
//

import Foundation

struct ForecastDay: Codable {
    let date: String
    let dateEpoch: Int
    let day: Day
    let hours: [Hour]
    
    private enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day
        case hours = "hour"
    }
    
}
