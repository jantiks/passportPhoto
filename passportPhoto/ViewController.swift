//
//  ViewController.swift
//  passportPhoto
//
//  Created by Tigran on 12/20/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit
import CropViewController
import TOCropViewController

class ImportController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,CropViewControllerDelegate {
    var currentImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarArray = tabBarController?.tabBar.items {
            for i in 1..<tabBarArray.count {
                tabBarArray[i].isEnabled = false
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        currentImage = image
        
        
        
        dismiss(animated: true)
        
        if let image = currentImage {
            print("passed")
            let cropController = CropViewController(croppingStyle: .default, image: image)
            cropController.delegate = self
            present(cropController, animated: true)
        }
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        <#code#>
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

