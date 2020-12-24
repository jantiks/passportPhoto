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
    var countries = [String]()

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
                    for i in 1..<485 {
                        
                        let element = elements[i]
                        guard let td = try? element.select("td").array() else { continue }
                        guard let ratioName = try? td[1].text() else { continue }
                        guard let sizeText = try? td[2].text() else { continue }
                        guard let countries = try? td[0].text() else { continue }
                        
                        
                        let widthArr = sizeText.split(separator: "x")
                        let heightArr = widthArr[1].split(separator: " ")
                        
                        guard let width = Double(widthArr[0]) else { continue }
                        guard let height = Double(heightArr[0]) else { continue }
                        
                        self?.aspecRatios.append((width: width, height: height, name: ratioName))
                        if !countries.isEmpty {
                            self?.countries.append(countries)
                        }
                        
                        
                    }
                }
            } catch let error {
                print("Error \(error)")
            }
        }
        
    
         
    }
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        print(countries, countries.count)
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
                guard let self = self else { return }
                
                for i in 0..<self.aspecRatios.count {
                    let line = self.aspecRatios[i]
                    configure.addCustomRatio(byHorizontalWidth: line.width, andHorizontalHeight: line.height, name: line.name)
                }
                configure.addCountries(country: self.countries)
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

