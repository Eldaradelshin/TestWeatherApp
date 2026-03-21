//
//  Day.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 16.03.2026.
//

import Foundation

struct Day: Codable {
    let maxTempC: Double
    let minTempC: Double
    let averageTempC: Double
    let condition: Condition
    
    private enum CodingKeys: String, CodingKey {
        case maxTempC = "maxtemp_c"
        case minTempC = "mintemp_c"
        case averageTempC = "avgtemp_c"
        case condition
    }
}
