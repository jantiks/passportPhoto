//
//  ViewController.swift
//  passportPhoto
//
//  Created by Tigran on 12/20/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit
import Mantis
import SwiftSoup

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
        
        let myUrlString = "https://makepassportphoto.com/blog/passport-photo-size-measurements/"
        guard let myUrl = URL(string: myUrlString) else { return }
        
        do {
            let myHtmlString = try String(contentsOf: myUrl, encoding: .utf8)
            let htmlContent = myHtmlString
            
            do {
                guard let doc = try? SwiftSoup.parse(htmlContent) else { return }
                guard let elements = try? doc.select("tr").array() else { return }
                
                for position in 1..<elements.count {
                    guard let element = try? elements[position] else { return }
                    guard let x = try? element.select("td").array() else { return }
                    print(x[1])
                    
                    
                }
                
                
            }
            
        } catch let error {
            print("Error \(error)")
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
            configure.addCustomRatio(byHorizontalWidth: 2, andHorizontalHeight: 2.5, name: "Vzgo")
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

