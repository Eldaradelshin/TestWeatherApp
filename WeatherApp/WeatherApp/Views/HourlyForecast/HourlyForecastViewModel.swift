//
//  HourlyForecastViewMoldel.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 19.03.2026.
//

import UIKit
import Combine

protocol HourlyForecastViewModelProtocol: AnyObject,
                                           UICollectionViewDataSource,
                                           UICollectionViewDelegate,
                                           UICollectionViewDelegateFlowLayout {
    
    var hourlyForecastData: [HourlyForecastData] { get set }
    
}

final class HourlyForecastViewModel: NSObject, HourlyForecastViewModelProtocol {
   
    // MARK: - Properties
    
    @Published var hourlyForecastData: [HourlyForecastData] = []
    
    
    var mockData: [HourlyForecastData] = [
        HourlyForecastData(time: "12", temperature: "13°", imaageUrl: ""),
        HourlyForecastData(time: "13", temperature: "11°", imaageUrl: ""),
        HourlyForecastData(time: "14", temperature: "11°", imaageUrl: ""),
        HourlyForecastData(time: "15", temperature: "10°", imaageUrl: ""),
        HourlyForecastData(time: "16", temperature: "8°", imaageUrl: ""),
        HourlyForecastData(time: "17", temperature: "8°", imaageUrl: ""),
        HourlyForecastData(time: "18", temperature: "7°", imaageUrl: ""),
    ]
}

extension HourlyForecastViewModel: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyForecastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourForecastCell.identifier, for: indexPath) as? HourForecastCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: hourlyForecastData[indexPath.row])
        
        
        return cell
    }
    
}

extension HourlyForecastViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
}
