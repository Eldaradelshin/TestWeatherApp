//
//  HourlyForecastView.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 17.03.2026.
//

import UIKit

final class HourlyForecastView: UIView {
    
    // MARK: - ViewModel
    
    private let viewModel: HourlyForecastViewModelProtocol
    
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
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.3
        return view
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "HOURLY FORECAST"
        titleLabel.font = .systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = .white.withAlphaComponent(0.6)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(HourForecastCell.self,
                                forCellWithReuseIdentifier: HourForecastCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
   
    // MARK: - Init
    
    init(viewModel: HourlyForecastViewModelProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupCollectionView()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func reloadCollectionView() {
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
    
    private func setupViews() {
        addSubview(container)
        container.insertSubview(blurView, at: 0)
        container.addSubview(titleLabel)
        container.addSubview(collectionView)
        
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
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}
