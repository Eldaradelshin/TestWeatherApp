//
//  HourForecastItem.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 19.03.2026.
//

import UIKit

class HourForecastCell: UICollectionViewCell{
    
    // MARK: - Identifier

    static let identifier = "HourForecastCell"
    
    // MARK: Subviews
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.textAlignment = .center
        return label
    }()
    
    private let iconView: UIImageView = {
        let iconView = UIImageView()
        // TO DO - Image Loadin
        iconView.image = UIImage(systemName: "sun.max.fill")
        iconView.tintColor = .systemYellow
        iconView.contentMode = .scaleAspectFit
        return iconView
    }()
    
    private let tempLabel: UILabel = {
        let tempLabel = UILabel()
        //tempLabel.text = "\(data.temperature)°"
        tempLabel.font = .systemFont(ofSize: 17, weight: .medium)
        tempLabel.textColor = .white
        tempLabel.textAlignment = .center
        return tempLabel
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        timeLabel.text = ""
        tempLabel.text = ""
    }
    
    // MARK: - Methods
    
    func configure(with data: HourlyForecastData) {
        timeLabel.text = data.time
        tempLabel.text = "\(data.temperature)"
        //iconView
    }
    
    private func setupViews() {
        stack.addArrangedSubview(timeLabel)
        stack.addArrangedSubview(iconView)
        stack.addArrangedSubview(tempLabel)
        
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
