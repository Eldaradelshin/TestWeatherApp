//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 18.03.2026.
//

import Foundation
import Combine

@MainActor
final class WeatherViewModel {
    
    enum WeatherRequestState {
        case notRequested
        case loading
        case success
        case failure
    }
    
    // MARK: - Properties
    
    let hourlyForecastViewModel: HourlyForecastViewModel
    let dailyForecastViewModel: DailyForecastViewModel
    
    private let networkService: NetworkServiceProtocol
    private let dataProvider: DataProviderProtocol
    private let locationManager: LocationManagerProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Published properties
    
    @Published var weatherData : WeatherForecastData?
    @Published var requestState: WeatherRequestState = .notRequested
    
    // MARK: - Init
    
    init(networkService: NetworkServiceProtocol,
         hourlyForecastViewModel: HourlyForecastViewModel,
         dailyForecastViewModel: DailyForecastViewModel,
         dataProvider: DataProviderProtocol,
         locationManager: LocationManagerProtocol) {
        self.networkService = networkService
        self.hourlyForecastViewModel = hourlyForecastViewModel
        self.dailyForecastViewModel = dailyForecastViewModel
        self.dataProvider = dataProvider
        self.locationManager = locationManager
        
        setupBindings()
    }
    
    // MARK: - Methods
    
    func requestAuthorizationStatus() {
        locationManager.requestLocationPermission()
    }
    
    func setupBindings() {
        guard let locationManager = locationManager as? LocationManager else { return }
        
        locationManager.$authorizationStatus
            .sink { [weak self] authorizatinStatus in
                switch authorizatinStatus {
                case .authorizationDenied:
                    return
                case .authorizationGranted:
                    self?.locationManager.requestLocation()
                    self?.fetchForecast()
                case .authorizationNotDetermined:
                    self?.requestAuthorizationStatus()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchForecast() {
        requestState = .loading
        Task {
            try? await getForecast()
        }
    }
    
    func getForecast() async throws {
        do {
            let forecastResponse = try await networkService.getForecast()
            
            let weatherData = dataProvider.getData(from: forecastResponse)
            self.requestState = .success
            self.weatherData = weatherData
            self.dailyForecastViewModel.dailyForecastData  = weatherData.dailyForecastData
            self.hourlyForecastViewModel.hourlyForecastData = weatherData.hourlyForecastData
        } catch {
            print("Error - \(error)")
            self.requestState = .failure
        }
    }
    
   
}
