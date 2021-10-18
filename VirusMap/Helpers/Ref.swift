//
//  Ref.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 5.02.21.
//

import FirebaseDatabase
import FirebaseStorage

let REF_VIRUS = "viruses"
let GALLERY = "gallery"
let URL_STORAGE_PROFILE = "gs://viruses-5d58d.appspot.com"

let STORAGE_PROFILE = "profile"

class Ref {
    
    let databaseRoot = Database.database(url: "https://viruses-5d58d-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    
    func databaseViruses() -> DatabaseReference {
        return databaseRoot.child(REF_VIRUS)
    }
    
    func databaseSpecificVirus(uid: String) -> DatabaseReference {
        return databaseViruses().child(uid)
    }
    
    func databaseGalleries() -> DatabaseReference {
        return databaseRoot.child(GALLERY)
    }
    
    func databaseSpecificGallery(uid: String) -> DatabaseReference {
        return databaseGalleries().child(uid)
    }
    
    // Storage Ref
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_PROFILE)
    
    func storageGallery() -> StorageReference {
        return storageRoot.child(GALLERY)
    }
    
    var storageProfile: StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    
    func storageGallerySpeceificUser(uid: String) -> StorageReference {
        return storageGallery().child(uid)
    }
    
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
}
