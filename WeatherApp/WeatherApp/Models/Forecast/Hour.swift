//
//  Hour.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 16.03.2026.
//

import Foundation

struct Hour: Codable {
    let timeEpoch: Int
    let time: String
    let tempC: Double
    let isDay: Int
    let condition: Condition
    
    private enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
        case tempC = "temp_c"
        case isDay = "is_day"
        case condition
        
        
    }
}
