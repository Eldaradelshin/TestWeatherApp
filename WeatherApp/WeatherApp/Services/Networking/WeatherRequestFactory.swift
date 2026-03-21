//
//  WeatherRequestFactory.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 15.03.2026.
//

import Foundation

// MARK: - Protocol

protocol WeatherRequestFactoryProtocol: AnyObject {
    func currentWeatherRequest(with coordinates: Coordinates) throws -> URLRequest
    func currentDayForecast(with coordinates: Coordinates, days: Int) throws -> URLRequest
}

// MARK: - Enums

enum HTTPMethod: String {
    case get  = "GET"
    case post = "POST"
}

enum Paths: String {
    case currentWeather = "current.json"
    case forecast = "forecast.json"
}



final class WeatherRequestFactory: WeatherRequestFactoryProtocol {
    
    init(with config: Config) {
        self.baseUrl = config.baseURL
        self.apiKey = config.apiKey
        self.forecastDays = config.forecastDays
    }
    
    // MARK: - Properties
    
    private let baseUrl: String
    private let apiKey: String
    private let forecastDays: Int
    
    // MARK: - Methods
    
    func currentWeatherRequest(with coordinates: Coordinates) throws -> URLRequest {
        
        guard let baseUrl = URL(string: baseUrl) else {
            throw NetworkError.invalidUrl
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: "\(coordinates.latitude),\(coordinates.longitude)")
        ]
        
        let fullUrl = baseUrl
            .appending(path: Paths.currentWeather.rawValue)
            .appending(queryItems: queryItems)
        
        return URLRequest(url: fullUrl)
    }
    
    func currentDayForecast(with coordinates: Coordinates, days: Int) throws -> URLRequest {
     
        
        guard let baseUrl = URL(string: baseUrl) else {
            throw NetworkError.invalidUrl
        }
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: "\(coordinates.latitude),\(coordinates.longitude)"),
            URLQueryItem(name: "days", value: "\(days)")
        ]
        
        let fullUrl = baseUrl
            .appending(path: Paths.forecast.rawValue)
            .appending(queryItems: queryItems)
        
        return URLRequest(url: fullUrl)
    }
}
