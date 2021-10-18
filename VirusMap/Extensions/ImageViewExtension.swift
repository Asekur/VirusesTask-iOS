//
//  Extension.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 6.02.21.
//

import Foundation
import UIKit

var imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadPhoto(urlString: String) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil { return }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
            }).resume()
    }
    
    func roundImage() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = self.layer.frame.height / 2
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.isUserInteractionEnabled = true
    }
}
