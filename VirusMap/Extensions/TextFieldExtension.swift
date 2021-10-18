//
//  TextFieldExtension.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 19.03.21.
//

import UIKit

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setupGrayTextField() {
        textColor = .white
        font = UIFont(name: "Verdana", size: 15)
        layer.cornerRadius = 12
        backgroundColor = .clear
        layer.backgroundColor = CGColor(gray: 0.3, alpha: 0.8)
    }
    
    func setIcon(named: String) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        imageView.image = UIImage(named: named)
        let iconContainerView: UIView = UIView(frame:
                       CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(imageView)
        iconContainerView.tintColor = .white
        leftView = iconContainerView
        leftViewMode = UITextField.ViewMode.always
    }
}
