//
//  Virus.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 3.02.21.
//

import Foundation

class Virus {
    var uid: String
    var fullName: String
    var nickName: String
    var password: String
    var year: Int
    var mortality: Int
    var domain: String
    var image: String
    var country: String
    var continent: String
    var link: String
    
    init(dictionary: Dictionary<String, Any>) {
        uid = dictionary[UID] as? String ?? ""
        fullName = dictionary[FULL_NAME] as? String ?? ""
        nickName = dictionary[NICKNAME] as? String ?? ""
        password = dictionary[PASSWORD] as? String ?? ""
        year = Int(dictionary[YEAR] as? String ?? "") ?? 0
        mortality = Int(dictionary[MORTALITY] as? String ?? "") ?? 0
        domain = dictionary[MYDOMAIN] as? String ?? ""
        image = dictionary[PROFILE_IMAGE_URL] as? String ?? ""
        country = dictionary[COUNTRY] as? String ?? ""
        continent = dictionary[CONTINENT] as? String ?? ""
        link = dictionary[VIDEO_LINK] as? String ?? ""
    }
}
