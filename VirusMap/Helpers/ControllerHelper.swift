//
//  ControllerHelper.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 18.02.21.
//

import UIKit

class ControllerHelper {
    
    func changeVC(identifier: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyboard.instantiateViewController(identifier: identifier)
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.rootViewController = newViewController
    }
}
