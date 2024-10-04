//
//  FirebaseStorageManager.swift
//  OpenMarket
//
//  Created by 이가을 on 10/4/24.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {
    
    static func uploadImage(images: [UIImage], completion: @escaping ([String]) -> Void) {
        var URLArr: [String] = []
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
            //print("\(#function): imageName -> \(imageName)")
            
            let firebaseReference = Storage.storage().reference().child("\(imageName)")
            firebaseReference.putData(imageData, metadata: metaData) { metaData, error in
                firebaseReference.downloadURL { url, _ in
                    guard let URL = url else {
                        print("\(#function): URL -> nil!!!")
                        return
                    }
                    URLArr.append(URL.absoluteString) // ⭐️
                    if images.count == URLArr.count {                        completion(URLArr)
                    }
                }
            }
        }
    }
    
    static func downloadImage(urls: [String], completion: @escaping ([UIImage]) -> Void) {
        var imageArr: [UIImage] = []
        for url in urls {
            let reference = Storage.storage().reference(forURL: url)
            let megaByte = Int64(1 * 1024 * 1024)
            
            reference.getData(maxSize: megaByte) { data, error in
                guard let imageData = data else { return }
                
                imageArr.append(UIImage(data: imageData)!)
                if imageArr.count == urls.count {
                    completion(imageArr)
                }
            }
        }
    }
    
}
