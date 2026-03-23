//
//  WeatherRequestFactory.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 15.03.2026.
//

import Foundation

// MARK: - Protocol

protocol WeatherRequestFactoryProtocol: AnyObject {
    func currentWeatherRequest() throws -> URLRequest
    func currentDayForecast() throws -> URLRequest
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
    
    init(with config: Config, locationManager: LocationManagerProtocol) {
        self.config = config
        self.locationManager = locationManager
    }
    
    // MARK: - Properties

    private let config: Config
    private let locationManager: LocationManagerProtocol
    
    // MARK: - Methods
    
    func currentWeatherRequest() throws -> URLRequest {
        
        guard let baseUrl = URL(string: config.baseURL) else {
            throw NetworkError.invalidUrl
        }
        
        let coordinates = locationManager.currentLocation()
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: config.apiKey),
            URLQueryItem(name: "q", value: "\(coordinates.latitude),\(coordinates.longitude)")
        ]
        
        let fullUrl = baseUrl
            .appending(path: Paths.currentWeather.rawValue)
            .appending(queryItems: queryItems)
        
        return URLRequest(url: fullUrl)
    }
    
    func currentDayForecast() throws -> URLRequest {
        
        guard let baseUrl = URL(string: config.baseURL) else {
            throw NetworkError.invalidUrl
        }
        
        let coordinates = locationManager.currentLocation()
        
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: config.apiKey),
            URLQueryItem(name: "q", value: "\(coordinates.latitude),\(coordinates.longitude)"),
            URLQueryItem(name: "days", value: "\(config.forecastDays)")
        ]
        
        let fullUrl = baseUrl
            .appending(path: Paths.forecast.rawValue)
            .appending(queryItems: queryItems)
        
        return URLRequest(url: fullUrl)
    }
}
