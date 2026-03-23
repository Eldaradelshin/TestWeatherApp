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
    
    // MARK: - Error container
    
    private let errorContainer: UIView = {
        let view = UIView()
        view.isHidden = true
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let errorIconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.2)
        view.layer.cornerRadius = 48
        return view
    }()
    
    private let errorIconView: UIImageView = {
        let imageView = UIImageView()
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 64, weight: .light)
        imageView.image = UIImage(systemName: "exclamationmark.circle", withConfiguration: iconConfig)
        imageView.tintColor = .systemRed.withAlphaComponent(0.8)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let errorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Something Went Wrong"
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Unable to load weather data. Please try again later."
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Try Again", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.2)
        button.layer.cornerRadius = 24
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
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
        setupErrorView()
        setupRetryButton()
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
    
    // MARK: - Error view
    
    @objc private func retryButtonTapped() {
        // Animate button press
        UIView.animate(withDuration: 0.1, animations: {
            self.retryButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.retryButton.transform = .identity
            }
        }
        viewModel.fetchForecast()
    }
    
    private func setupRetryButton() {
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
    
    private func setupErrorView() {
        view.addSubview(errorContainer)
        errorContainer.addSubview(errorIconContainer)
        errorIconContainer.addSubview(errorIconView)
        errorContainer.addSubview(errorTitleLabel)
        errorContainer.addSubview(errorMessageLabel)
        
        errorContainer.addSubview(retryButton)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isUserInteractionEnabled = false
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 24
        blurView.clipsToBounds = true
        
        retryButton.insertSubview(blurView, at: 0)
        
        NSLayoutConstraint.activate([
            errorContainer.topAnchor.constraint(equalTo: view.topAnchor),
            errorContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            errorIconContainer.centerXAnchor.constraint(equalTo: errorContainer.centerXAnchor),
            errorIconContainer.centerYAnchor.constraint(equalTo: errorContainer.centerYAnchor, constant: -100),
            errorIconContainer.widthAnchor.constraint(equalToConstant: 96),
            errorIconContainer.heightAnchor.constraint(equalToConstant: 96),
            
            errorIconView.centerXAnchor.constraint(equalTo: errorIconContainer.centerXAnchor),
            errorIconView.centerYAnchor.constraint(equalTo: errorIconContainer.centerYAnchor),
            errorIconView.widthAnchor.constraint(equalToConstant: 64),
            errorIconView.heightAnchor.constraint(equalToConstant: 64),
            
            errorTitleLabel.topAnchor.constraint(equalTo: errorIconContainer.bottomAnchor, constant: 32),
            errorTitleLabel.leadingAnchor.constraint(equalTo: errorContainer.leadingAnchor, constant: 24),
            errorTitleLabel.trailingAnchor.constraint(equalTo: errorContainer.trailingAnchor, constant: -24),
            
            errorMessageLabel.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: 12),
            errorMessageLabel.leadingAnchor.constraint(equalTo: errorContainer.leadingAnchor, constant: 24),
            errorMessageLabel.trailingAnchor.constraint(equalTo: errorContainer.trailingAnchor, constant: -24),
            
            retryButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 32),
            retryButton.centerXAnchor.constraint(equalTo: errorContainer.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 160),
            retryButton.heightAnchor.constraint(equalToConstant: 48),
            
            blurView.topAnchor.constraint(equalTo: retryButton.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: retryButton.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: retryButton.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: retryButton.topAnchor)
        ])
    }
    
    private func setViewsVisibility(with state: WeatherViewModel.WeatherRequestState = .notRequested) {
        switch state {
        case .notRequested:
            currentWeatherView.isHidden = true
            dailyForecastView.isHidden = true
            hourlyForecastView.isHidden = true
            scrollView.alpha = 0
            hideLoader()
        case .loading:
            hideErrorView()
            showLoader()
        case .success:
            hideLoader()
            showViews()
        case .failure:
            hideLoader()
            showErrorView()
        }
    }
    
    private func showViews() {
        currentWeatherView.isHidden = false
        dailyForecastView.isHidden = false
        hourlyForecastView.isHidden = false
        scrollView.alpha = 1
    }
    
    private func hideErrorView() {
        errorContainer.isHidden = true
        errorContainer.alpha = 0
    }
    
    private func showErrorView() {
        errorContainer.isHidden = false
        errorContainer.alpha = 1
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
