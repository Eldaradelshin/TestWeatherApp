//
//  DailyForecastView.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 17.03.2026.
//


import UIKit

final class DailyForecastView: UIView {
    
    private let viewModel: DailyForecastViewModelProtocol
    
    // MARK: - Subviews
    
    private let container: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .white.withAlphaComponent(0.1)
        container.layer.cornerRadius = 16
        container.clipsToBounds = true
        return container
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0.3
        return blurView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "3-DAY FORECAST"
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = .white.withAlphaComponent(0.6)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 44
        tableView.register(DayForecastCell.self, forCellReuseIdentifier: DayForecastCell.identifier)
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    
    // MARK: - Init
    
    init(viewModel: DailyForecastViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupTableView()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    @MainActor
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
    
    private func setupViews() {
        addSubview(container)
        container.insertSubview(blurView, at: 0)
        container.addSubview(titleLabel)
        container.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            blurView.topAnchor.constraint(equalTo: container.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 132)
        ])
    }
}

