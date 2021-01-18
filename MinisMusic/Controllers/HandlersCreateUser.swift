//
//  HandlersCreateUser.swift
//  MinisMusic
//
//  Created by Ítalo Rufca on 30/08/2018.
//  Copyright © 2018 Ítalo Rufca. All rights reserved.
//

import UIKit

extension CreateUserController {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImage = editedImage
            
        } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originImage
        }
        userImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


