//
//  ViewController.swift
//  passportPhoto
//
//  Created by Tigran on 12/20/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit
import SwiftSoup

class ImportController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {    
    
    var currentImage: UIImage?
    var aspecRatios = [(width: Double, height: Double, name: String, sizeType: String)]()
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
                        
                        guard var ratioName = try? td[1].text() else { continue }
                        guard let sizeText = try? td[2].text() else { continue }
                        
                        guard let countries = try? td[0].text() else { continue }
                        
                        let widthArr = sizeText.split(separator: "x", maxSplits: 1, omittingEmptySubsequences: true)
                        let heightArr = widthArr[1].split(separator: " ")
                        var sizeType = ""
                        if heightArr.count == 2 {
                            sizeType = String(heightArr[1])
                        } else {
                            sizeType = "cm"
                        }
                        
                        let problematicNames = ratioName.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
                        if problematicNames[0].contains("US") {
                            ratioName = "United States" + " " + problematicNames[1]
                        } else if problematicNames[0].contains("UK") {
                            ratioName = "United Kingdom" + " " + problematicNames[1]
                        } else if problematicNames[0].contains("EU") {
                            ratioName = "European Union" + " " + problematicNames[1]
                        } else if problematicNames[0].contains("UAE") {
                            ratioName = "United Arab Emirates" + " " + problematicNames[1]
                        }
                        
                        
                        guard let width = Double(widthArr[0]) else { continue }
                        guard let height = Double(heightArr[0]) else { continue }
                        
                        self?.aspecRatios.append((width: width, height: height, name: ratioName, sizeType: sizeType ))
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        dismiss(animated: true)
        if let svc = self.storyboard?.instantiateViewController(withIdentifier: "selectCountry") as? SelectCountryViewController {
            svc.countries = countries
            svc.aspecRatios = aspecRatios
            svc.selectedImage = image
            self.present(svc, animated: true)
        }
        
        
        currentImage = image
        
        
        
    }
    
    func definePixelOrCm(name: String) -> [(width: Double, height: Double)] {
        var widthInPixels: Double = 600
        var heightInPixels: Double = 600
    
        if let sizeArr = name.components(separatedBy: " ").last {
            if let width = Double(sizeArr.components(separatedBy: ":")[0]) {
                
                if width > 100 {
                    widthInPixels = width
                } else {
                    widthInPixels = width * 118
                }
                
            }
            if let height = Double(sizeArr.components(separatedBy: ":")[1]) {
                if height > 100 {
                    heightInPixels = height
                } else {
                    heightInPixels = height * 118
                }
                
            }
            
            return [(widthInPixels, heightInPixels)]
        }
        else {
            return [(widthInPixels, heightInPixels)]
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

