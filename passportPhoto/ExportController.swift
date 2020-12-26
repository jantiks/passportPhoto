//
//  ExportController.swift
//  passportPhoto
//
//  Created by Tigran on 12/20/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit

class ExportController: UIViewController, UIPrintInteractionControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var cropAgainButton: UIButton!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var printButton: UIButton!
    var croppedImage: UIImage?
    
    
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        cropAgainButton.layer.borderWidth = 3
        cropAgainButton.layer.cornerRadius = 5
        cropAgainButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        downloadButton.layer.borderWidth = 3
        downloadButton.layer.cornerRadius = 5
        downloadButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        printButton.layer.borderWidth = 3
        printButton.layer.cornerRadius = 5
        printButton.layer.borderColor = UIColor.systemBlue.cgColor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let image = croppedImage {
            imageView.image = image
        }
    }
    
    
    @IBAction func downloadTapped(_ sender: Any) {
        
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func printTapped(_ sender: Any) {
        guard var img = imageView.image else { return }
        

        let printController = UIPrintInteractionController.shared
        printController.delegate = self
        let paperSize = printController.printPaper?.paperSize
//        print(paperSize)
        printController.showsPaperSelectionForLoadedPapers = true
        
        

        let size = CGSize(width: 500, height: 500)

        let  changedImg = imageResize(croppingImageView: imageView, sizeChange: size)
        
        
        printController.printingItems = [changedImg]

        printController.present(animated: true, completionHandler: nil)

        
    }
    
    
    func imageResize(croppingImageView: UIImageView, sizeChange: CGSize) -> UIImage {
        
        let img = croppingImageView
        let newView = UIView()
        newView.frame.size = CGSize(width: 500, height: 500)
        print(newView.frame.size)

        newView.backgroundColor = .blue
        newView.addSubview(img)
        

        let rederedImage = newView.asImage()
        return rederedImage
        
//        NSLayoutConstraint.activate([img.topAnchor.constraint(equalTo:                            view.layoutMarginsGuide.topAnchor, constant: 50),
//                                    img.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 50)])

//        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
//
//        newView.draw(CGRect(origin: CGPoint(x: 0, y: 0), size: sizeChange))
//
        
//        if let scaledImage = UIGraphicsGetImageFromCurrentImageContext() {
//            UIGraphicsEndImageContext()
//            print("passed")
//            return croppingImageView.image!
//
//        } else {
//            return croppingImageView.image!
//        }
        
    }
    
    
    @IBAction func cropAgainTapped(_ sender: Any) {
        tabBarController?.tabBar.items?[1].isEnabled = false
        tabBarController?.selectedIndex = 0
    }
    
    
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image has beed save to your photos", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
}

extension UIView {
    
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContect in
            layer.render(in: rendererContect.cgContext)
            
        }
    }
    
}
