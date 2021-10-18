//
//  LocalizeUtils.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 24.02.21.
//

import Foundation

class LocalizeUtils: NSObject {
    static let defaultLocalizer = LocalizeUtils()
    var bundle = Bundle.main
    
    func setSelectedLanguage(lang: String) {
        guard let langPath = Bundle.main.path(forResource: lang, ofType: "lproj") else {
            bundle = Bundle.main
            return
        }
        
        bundle = Bundle(path: langPath)!
    }
       
    func stringForKey(key: String) -> String {
       return bundle.localizedString(forKey: key, value: "", table: nil)
    }
}
