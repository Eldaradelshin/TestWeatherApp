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
    
    // MARK: - LoadingViews
    
    private let loadingContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .white
        indicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        indicator.startAnimating()
        
        return indicator
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Loading weather..."
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        return label
    }()
    
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
        setupLoadingView()
        setViewsVisibility()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.requestAuthorizationStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    // MARK: - Methods
    
    private func setupBindings() {
        viewModel.$weatherData
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                guard let data = data else { return }
                self?.currentWeatherView.updateView(with: data.currentWeatherData)
                self?.updateGradientColor(isDay: data.isDay)
                self?.dailyForecastView.reloadTableView()
                self?.hourlyForecastView.reloadCollectionView()
            }
            .store(in: &cancellables)
        viewModel.$requestState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.setViewsVisibility(with: state)
            }
            .store(in: &cancellables)
    }
    
    private func setupLoadingView() {
        view.addSubview(loadingContainer)
        loadingContainer.addSubview(activityIndicator)
        loadingContainer.addSubview(loadingLabel)
        
        NSLayoutConstraint.activate([
            loadingContainer.topAnchor.constraint(equalTo: view.topAnchor),
            loadingContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: loadingContainer.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingContainer.centerYAnchor, constant: -20),
            
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 24),
            loadingLabel.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor)
        ])
        
    }
    
    private func setViewsVisibility(with state: WeatherViewModel.WeatherRequestState = .notRequested) {
        /*
        
        */
        switch state {
        case .notRequested:
            currentWeatherView.isHidden = true
            dailyForecastView.isHidden = true
            hourlyForecastView.isHidden = true
            scrollView.alpha = 0
            hideLoader()
        case .loading:
            showLoader()
        case .success:
            hideLoader()
            showViews()
        case .failure:
            hideLoader()
        }
    }
    
    private func showViews() {
        currentWeatherView.isHidden = false
        dailyForecastView.isHidden = false
        hourlyForecastView.isHidden = false
        scrollView.alpha = 1
    }
    
    private func hideLoader() {
        self.loadingContainer.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    private func showLoader() {
        self.activityIndicator.startAnimating()
        self.loadingContainer.isHidden = false
    }
    
    private func updateGradientColor(isDay: Bool) {
        let colors: [CGColor]
        
        if isDay {
            colors = [
                UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1.0).cgColor,
                UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0).cgColor
            ]
        } else {
            colors = [
                UIColor(red: 0.12, green: 0.09, blue: 0.29, alpha: 1.0).cgColor,
                UIColor(red: 0.35, green: 0.16, blue: 0.45, alpha: 1.0).cgColor,
                UIColor(red: 0.11, green: 0.16, blue: 0.31, alpha: 1.0).cgColor
            ]
        }
        
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = isDay ? [0.0, 1.0] : [0.0, 0.5, 1.0]
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
