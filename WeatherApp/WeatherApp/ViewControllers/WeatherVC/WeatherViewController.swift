//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 17.03.2026.
//

import UIKit
import Combine

final class WeatherViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: WeatherViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Subviews
    
    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0).cgColor,
            UIColor(red: 0.4, green: 0.6, blue: 0.8, alpha: 1.0).cgColor
        ]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        
        return layer
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    private let currentWeatherView = CurrentWeatherView()

    private let hourlyForecastView: HourlyForecastView
    private let dailyForecastView: DailyForecastView
    
    // MARK: - Init
    
    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        self.hourlyForecastView = HourlyForecastView(viewModel: viewModel.hourlyForecastViewModel)
        self.dailyForecastView = DailyForecastView(viewModel: viewModel.dailyForecastViewModel)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupScrollView()
        setupContent()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Methods
    
    private func fetchData() {
        Task {
            try await viewModel.getForecast()
        }
    }
    
    private func setupBindings() {
        viewModel.$weatherData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let data = data else { return }
                self?.currentWeatherView.updateView(with: data.currentWeatherData)
            }
            .store(in: &cancellables)
        
        viewModel.dailyForecastViewModel.$dailyForecastData
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.dailyForecastView.reloadTableView()
            }
            .store(in: &cancellables)
        
        viewModel.hourlyForecastViewModel.$hourlyForecastData
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.hourlyForecastView.reloadCollectionView()
            }
            .store(in: &cancellables)
    }
    
    private func setupGradient() {
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupContent() {
        scrollView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Current Weather
        contentStack.addArrangedSubview(currentWeatherView)
        
        // Hourly Forecast
        contentStack.addArrangedSubview(hourlyForecastView)

        // Daily Forecast
        contentStack.addArrangedSubview(dailyForecastView)
    }
}
