//
//  Location.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 15.03.2026.
//

import Foundation

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let latitude: Double
    let longitude: Double
    let timezoneID: String
    let localtimeEpoch: Int
    let localtime: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case region
        case country
        case latitude  = "lat"
        case longitude = "lon"
        case timezoneID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}
