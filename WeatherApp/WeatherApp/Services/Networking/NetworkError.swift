//
//  NetworkError.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 16.03.2026.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case badStatusCode
}
