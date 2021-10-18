//
//  VirusCell.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 3.02.21.

import UIKit

class VirusCell: UITableViewCell {

    @IBOutlet weak var virusImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var domainYearLabel: UILabel!
    
    override func awakeFromNib() {
        backgroundColor = Constants.backgroundColor
        tintColor = .white
        let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        if let width = image?.size.width, let height = image?.size.height {
            let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            disclosureImageView.image = image
            accessoryView = disclosureImageView
        }
    }
    
    func setupCell(virus: Virus) {
        virusImageView.image = UIImage(named: virus.image)
        fullnameLabel.text = virus.fullName
        domainYearLabel.text = virus.domain.concatWithSeparator(value: String(virus.year), separator: ", ")
    }
}
