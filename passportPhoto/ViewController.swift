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
    
    var currentImage: UIImage?
    var aspecRatios = [(width: Double, height: Double, name: String)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarArray = tabBarController?.tabBar.items {
                tabBarArray[1].isEnabled = false
            
        }
        
        //scrabbing data from website
        
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
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
                        guard let ratioName = try? x[1].text() else { return }
                        guard let sizeText = try? x[2].text() else { return }
                        
                        let widthArr = sizeText.split(separator: "x")
                        let heightArr = widthArr[1].split(separator: " ")
                        
                        guard let width = Double(widthArr[0]) else { return }
                        guard let height = Double(heightArr[0]) else { return }
                        
                        self?.aspecRatios.append((width: width, height: height, name: ratioName))
                        
                    }
                }
            } catch let error {
                print("Error \(error)")
            }
        }
        
    
         
    }
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[.originalImage] as? UIImage else { return }
        
        currentImage = image
        
        
        
        dismiss(animated: true)
        
        if let image = currentImage {
            
            let cropController = Mantis.cropViewController(image: image)
            cropController.delegate = self
            
            var configure = Mantis.Config()
            
            DispatchQueue.global(qos: .userInitiated).async {
                [weak self] in
                guard let count = self?.aspecRatios.count else { return }
                for i in 0..<count {
                    guard let line = self?.aspecRatios[i] else { continue }
                    configure.addCustomRatio(byHorizontalWidth: line.width, andHorizontalHeight: line.height, name: line.name)
                }
            }
            
            
            
            DispatchQueue.main.async {
                [weak self] in
                cropController.config = configure
                self?.present(cropController, animated: true)
            }
            
        }
        
    }
    

    @IBAction func galleryTapped(_ sender: Any) {
        
        DispatchQueue.main.async {
            [weak self] in
            let picker = UIImagePickerController()
            picker.delegate = self
            self?.present(picker, animated: true)
        }
        
    }
    @IBAction func cameraTapped(_ sender: Any) {
        
        DispatchQueue.main.async {
            [weak self] in
            let picker = UIImagePickerController()
            picker.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                self?.present(picker, animated: true)
                
            }
        }
        
        
        
        
    }

    
}

