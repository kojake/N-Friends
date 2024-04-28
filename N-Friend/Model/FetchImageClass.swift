//
//  FetchImageClass.swift
//  N-Friend
//
//  Created by kaito on 2024/04/29.
//

import Foundation
import UIKit
import FirebaseStorage


class FetchImageClass {
    //UserImage
    func FetchUserImage(username: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = Storage.storage().reference(forURL: "gs://n-friends.appspot.com").child(username)
        
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            } else if let data = data, let uiImage = UIImage(data: data) {
                completion(uiImage)
            } else {
                completion(nil)
            }
        }
    }
}
