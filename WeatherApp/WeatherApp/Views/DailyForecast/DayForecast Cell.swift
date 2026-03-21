//
//  DayForecast Cell.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 20.03.2026.
//

import UIKit

final class DayForecastCell: UITableViewCell {
    
    // MARK: - Identifier
    
    static let identifier = "DayForecastCell"
    
    // MARK: - Subviews
    
    private let dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.text = ""
        dayLabel.font = .systemFont(ofSize: 17, weight: .regular)
        dayLabel.textColor = .white
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        return dayLabel
    }()
    
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconView: UIImageView = {
        let iconView = UIImageView()
        //iconView.image = UIImage(systemName: data.iconName)
        //iconView.tintColor = .systemYellow.withAlphaComponent(0.9)
        iconView.image = UIImage(systemName: "sun.max.fill")
        iconView.tintColor = .systemYellow.withAlphaComponent(0.9)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    
    private let lowLabel: UILabel = {
        let lowLabel = UILabel()
        //lowLabel.text = "\(data.low)°"
        lowLabel.text = ""
        lowLabel.font = .systemFont(ofSize: 17, weight: .regular)
        lowLabel.textColor = .white.withAlphaComponent(0.6)
        lowLabel.translatesAutoresizingMaskIntoConstraints = false
        return lowLabel
    }()
    
    private let highLabel: UILabel = {
        let highLabel = UILabel()
        //highLabel.text = "\(data.high)°"
        highLabel.text = ""
        highLabel.font = .systemFont(ofSize: 17, weight: .regular)
        highLabel.textColor = .white
        highLabel.translatesAutoresizingMaskIntoConstraints = false
        return highLabel
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func configure(with data: DailyForecastData) {
        dayLabel.text = data.day
        conditionLabel.text = data.condition
        highLabel.text = data.highTempC
        lowLabel.text = data.lowTempC
    }
    
    override func prepareForReuse() {
        dayLabel.text = ""
        conditionLabel.text = ""
        lowLabel.text = ""
        highLabel.text = ""
    }
    
    private func setupViews() {
        contentView.backgroundColor = .clear
        contentView.addSubview(dayLabel)
        contentView.addSubview(conditionLabel)
        contentView.addSubview(iconView)
        contentView.addSubview(lowLabel)
        contentView.addSubview(highLabel)
        
        NSLayoutConstraint.activate([
            
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dayLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.33),
            
            iconView.centerXAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 8),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            conditionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            conditionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            highLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            highLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            lowLabel.trailingAnchor.constraint(equalTo: highLabel.leadingAnchor, constant: -12),
            lowLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
