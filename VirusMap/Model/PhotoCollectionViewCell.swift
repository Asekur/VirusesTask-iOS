//
//  PhotoCollectionViewCell.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 21.02.21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    func setupCell(url: String) {
        cellImage.loadPhoto(urlString: url)
    }
}
