//
//  ImagePickerView.swift
//  N-Friend
//
//  Created by kaito on 2024/03/05.
//

import Foundation
import UIKit
import SwiftUI
import FirebaseFirestore

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var UserImage: UIImage?
    @Binding var Showshould_ImagePickerView: Bool

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.UserImage = selectedImage
            }
            parent.Showshould_ImagePickerView = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.Showshould_ImagePickerView = false
        }
    }    
}
