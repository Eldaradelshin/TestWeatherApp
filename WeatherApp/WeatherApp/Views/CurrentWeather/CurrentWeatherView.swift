//
//  CurrentWeatherView.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 17.03.2026.
//

import UIKit

class CurrentWeatherView: UIView {
    
    // MARK: - Properties
    
    private var currentWeatherData: CurrentWeatherData? = nil {
        didSet {
            setNeedsLayout()
        }
    }
    
    // MARK: - Subviews
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = .systemFont(ofSize: 28, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // TODO Доделать загрузку
    private let weatherIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: "sun.max.fill")
        iconView.tintColor = .systemYellow
        iconView.contentMode = .scaleAspectFit
        return iconView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "--°"
        label.font = .systemFont(ofSize: 72, weight: .thin)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.text = "--"
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()
    
    private let highLowLabel: UILabel = {
        let label = UILabel()
        label.text = "H: --° L: --°"
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.7)
        label.textAlignment = .center
        return label
    }()
    
    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    // MARK: - Method
    
    func updateView(with data: CurrentWeatherData) {
        self.currentWeatherData = data
    }
    
    func updateUI() {
        guard let data = currentWeatherData else { return }
        
        locationLabel.text = data.location
        //weatherIconView image loading
        temperatureLabel.text = data.temperature
        conditionLabel.text = data.condition
        highLowLabel.text = data.highLowTemp
    }
    
    private func setupViews() {
        // Add to Stack
        let views = [
            locationLabel,
            weatherIconView,
            temperatureLabel,
            conditionLabel,
            highLowLabel
        ]
        
        for view in views {
            contentStack.addArrangedSubview(view)
        }
        
        addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            weatherIconView.heightAnchor.constraint(equalToConstant: 96),
            weatherIconView.widthAnchor.constraint(equalToConstant: 96)
        ])
    }
}
