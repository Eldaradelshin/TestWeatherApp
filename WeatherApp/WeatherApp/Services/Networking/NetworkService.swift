//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 15.03.2026.
//

import Foundation


protocol NetworkServiceProtocol: AnyObject {
    func getCurrentWeather() async throws -> CurrentWeatherResponse
    func getForecast() async throws -> ForecastResponse
    
}

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    
    private let weatherRequestFactory: WeatherRequestFactoryProtocol
    
    // MARK: - Init
    
    init(weatherRequestFactory: WeatherRequestFactoryProtocol) {
        self.weatherRequestFactory = weatherRequestFactory
    }
    
    // MARK: - Methods
    
    func getCurrentWeather() async throws -> CurrentWeatherResponse {
        let currentWeatherRequest = try weatherRequestFactory.currentWeatherRequest()
        let (data, response) = try await URLSession.shared.data(for: currentWeatherRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badStatusCode
        }
        
        let decoder = JSONDecoder()
        let currentWeatherResponse = try decoder.decode(CurrentWeatherResponse.self, from: data)
        
        return currentWeatherResponse
    }
    
    func getForecast() async throws -> ForecastResponse {
        let forecastRequest = try weatherRequestFactory.currentDayForecast()
        let (data, response) = try await URLSession.shared.data(for: forecastRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badStatusCode
        }
        
        let decoder = JSONDecoder()
        let forecastResponse = try decoder.decode(ForecastResponse.self, from: data)
        
        return forecastResponse
    }
}
