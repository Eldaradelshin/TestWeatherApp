//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 21.03.2026.
//

import Foundation
import CoreLocation
import Combine

protocol LocationManagerProtocol {
    func requestLocation()
    func requestLocationPermission()
    func currentLocation() -> Coordinates
}

enum AuthorizationStatus {
    case authorizationGranted
    case authorizationNotDetermined
    case authorizationDenied
}

final class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerProtocol {
    
    // MARK: - Properties
    
    private var currentLocationCoordinates: Coordinates?
    private let defaultCoordinates = Coordinates(latitude: 55.7558, longitude: 37.6173)
    
    private let clLocationManager = CLLocationManager()
    
    @Published var authorizationStatus: AuthorizationStatus = .authorizationNotDetermined
    
    // MARK: - Init
    
    override init() {
        super.init()
        clLocationManager.delegate = self
        clLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    // MARK: - Methods
    
    func requestLocationPermission() {
        clLocationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        clLocationManager.startUpdatingLocation()
    }
    
    func currentLocation() -> Coordinates {
        return currentLocationCoordinates ?? defaultCoordinates
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        self.currentLocationCoordinates = Coordinates(latitude: latitude, longitude: longitude)
        print("Текущие координаты \(currentLocationCoordinates)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Ошибка определения местоположения: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self.authorizationStatus = .authorizationNotDetermined
        case .authorizedAlways:
            self.authorizationStatus = .authorizationGranted
        case .authorizedWhenInUse:
            self.authorizationStatus = .authorizationGranted
        default:
            self.authorizationStatus = .authorizationDenied
        }
    }
}

