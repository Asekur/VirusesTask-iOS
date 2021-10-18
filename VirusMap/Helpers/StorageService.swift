//
//  StorageService.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 5.02.21.
//

import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class StorageService {

    static func savePhotoToGallery(image: UIImage, uid: String) {
        guard let imageData: Data = image.jpegData(compressionQuality: 0.4) else {
              return
          }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        let ref = Ref().databaseSpecificGallery(uid: uid).childByAutoId()
        let storageRef = Ref().storageGallerySpeceificUser(uid: uid).child(ref.key ?? "default")
        
        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                return
            }
            storageRef.downloadURL(completion: { (url, error) in
                guard let urlString = url?.absoluteString else { return }
                ref.setValue(urlString)
                print(urlString)
            })
        }
    }
    
    static func saveInfo(uid: String, dict: Dictionary<String, Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        Ref().databaseSpecificVirus(uid: uid).updateChildValues(dict, withCompletionBlock: { (error, _) in
            if error == nil {
                onSuccess()
            } else {
                onError(error!.localizedDescription)
            }
        })
    }
}
