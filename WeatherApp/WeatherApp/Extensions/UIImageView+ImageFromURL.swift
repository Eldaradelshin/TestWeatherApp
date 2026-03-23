//
//  UIImageView+ImageFromURL.swift
//  WeatherApp
//
//  Created by Эльдар Адельшин on 21.03.2026.
//

import UIKit

extension UIImageView {
    private static var imageCache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) async throws {
        self.image = placeholder
        
        if let cachedImage = UIImageView.imageCache.object(forKey: url.absoluteString as NSString) {
            await MainActor.run {
                self.image = cachedImage
            }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "Invalid image data", code: 1, userInfo: nil)
            }
            
            UIImageView.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            
            await MainActor.run {
                self.image = image
            }
        } catch {
            throw error
        }
    }
    
    func safeLoadImage(from urlString: String, placeholder: UIImage? = nil ) {
        let imageString = "https:"+urlString
        
        guard let imageUrl = URL(string: imageString) else { return }
        
        Task {
            do {
                try await self.loadImage(from: imageUrl)
            } catch {
                print(error)
            }
        }
    }
}
