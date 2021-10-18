//
//  ViewControllerExtension.swift
//  StudentMap
//
//  Created by Angelina Rusinovich on 23.02.21.
//

import UIKit
import JGProgressHUD

extension UIViewController {
    
    @objc func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupSimpleProgressHUD() -> JGProgressHUD {
        let hud = JGProgressHUD()
        hud.vibrancyEnabled = true
        hud.textLabel.text = "Loading..."
        hud.show(in: self.view)
        return hud
    }
    
    func showSucess(hud: JGProgressHUD) {
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.textLabel.text = "Done!"
        hud.dismiss(afterDelay: 1.0)
    }
    
    func showError(hud: JGProgressHUD, error: String) {
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        hud.textLabel.text = error
        hud.dismiss(afterDelay: 1.5)
    }
    
    func setupGrayTextField(textFields: [UITextField]) {
        for textField in textFields {
            textField.setupGrayTextField()
        }
    }
    
    func validateFieldsLength(fields: [String]) -> Bool {
        let minLength = 1
        for field in fields {
            if field.count < minLength {
                return false
            }
        }
        return true
    }
}
