//
//  ViewController.swift
//  passportPhoto
//
//  Created by Tigran on 12/20/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit
import Mantis

class ImportController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        
        dismiss(animated: true)
        let croppedImage = cropped
        tabBarController?.viewControllers?.forEach({
            if let controller = $0 as? ExportController {
                controller.croppedImage = croppedImage
                tabBarController?.tabBar.items?[1].isEnabled = true
                tabBarController?.selectedIndex = 1
            }
        })
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        dismiss(animated: true)
    }
    
    var currentImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarArray = tabBarController?.tabBar.items {
                tabBarArray[1].isEnabled = false
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        currentImage = image
        
        
        
        dismiss(animated: true)
        
        if let image = currentImage {
            let cropController = Mantis.cropViewController(image: image)
            cropController.delegate = self
            
            var configure = Mantis.Config()
            configure.addCustomRatio(byHorizontalWidth: 11, andHorizontalHeight: 12)
            cropController.config = configure
            present(cropController, animated: true)
        }
        
    }
    

    @IBAction func galleryTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true)
    }
    @IBAction func cameraTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            present(picker, animated: true)
            
        }
        
        
    }

    
}

