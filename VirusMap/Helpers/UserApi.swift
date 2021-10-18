//
//  Auth.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 5.02.21.
//

import Foundation
import Firebase
import FirebaseAuth

let UID = "uid"
let FULL_NAME = "full_name"
let NICKNAME = "nickname"
let PASSWORD = "password"
let YEAR = "year"
let MYDOMAIN = "domain"
let COUNTRY = "country"
let MORTALITY = "mortality"
let CONTINENT = "continent"

let PROFILE_IMAGE_URL = "profileImageUrl"
let VIDEO_LINK = "video_link"

class UserApi {
    
    func signUp(fullName: String, password: String, nickName: String, year: String, image: String, mortality: String, domain: String, continent: String, country: String, onSuccess: @escaping() -> Void, onError: @escaping(_ error: String) -> Void) {
    
        let uuid = UUID().uuidString
        let dict: Dictionary<String, Any> = [
            UID: uuid,
            FULL_NAME: fullName,
            NICKNAME: nickName,
            PASSWORD: password,
            YEAR: year,
            MORTALITY: mortality,
            MYDOMAIN: domain,
            PROFILE_IMAGE_URL: image,
            COUNTRY: country,
            CONTINENT: continent,
            VIDEO_LINK: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
        ]
        
        Ref().databaseSpecificVirus(uid: uuid).updateChildValues(dict, withCompletionBlock: { (error, ref) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        })
    }
}
