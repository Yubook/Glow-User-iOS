//
//  JTImagePicker.swift
//  Presenta
//
//  Created by Jayesh Tejwani on 07/06/20.
//  Copyright © 2020 Chirag Patel. All rights reserved.
//

import Foundation
import UIKit

class JTImagePicker: NSObject {
    
    static var shared: JTImagePicker = JTImagePicker()

    var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        return picker
    }()
    
    weak var viewController: UIViewController!
    var pickImageCallback : ((UIImage) -> ())?
    
    func pickImage(_ viewController: UIViewController, isOpenCamera: Bool = false , _ callback: @escaping ((UIImage) -> ())) {
        self.viewController = viewController
        imagePicker.delegate = self
        pickImageCallback = callback
        if isOpenCamera {
            self.openCamera_Gallery(sourceType: .camera)
        } else {
            self.openImagePickerPopUp()
        }
    }
    
    func openImagePickerPopUp() {
        let alertSheet = UIAlertController(title: "Select Image" , message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "Camera" , style: .default, handler: { (action) in
            self.openCamera_Gallery(sourceType: .camera)
        }))
        alertSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.openCamera_Gallery(sourceType: .photoLibrary)
        }))
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alertSheet, animated: true, completion: nil)
    }
    
    func openCamera_Gallery(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        //d
        if sourceType == .camera{
            imagePicker.allowsEditing = false
        }
        viewController.present(imagePicker, animated: true, completion: nil)
    }
}

extension JTImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImg = info[.editedImage] as? UIImage {
            pickImageCallback?(pickedImg)
        }
        //d
        if let pickedImage = info[.originalImage] as? UIImage{
            pickImageCallback?(pickedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

