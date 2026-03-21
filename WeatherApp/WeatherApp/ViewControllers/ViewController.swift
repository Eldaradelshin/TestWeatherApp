//
//  ViewController.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 15.03.2026.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let networkService = NetworkService(weatherRequestFactory: WeatherRequestFactory(with: .shared), config: .shared)
        
        Task {
            do {
                let weatherResponse = try await networkService.getForecast()
            } catch {
                print(error)
            }
        }
    }
}

