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
    var sizeArr = [(width: Double, height: Double)]()
    var paperSize = CGSize(width: 2480, height: 3505) //a4 paper size in pixeles
    
    
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
        
        guard let img = imageView else { return }
        var choosPaperTitle = "Paper"
        var acTitle = "Paper and Quantity"
        let ac = UIAlertController(title: "Paper and Quantity", message: "Choose paper type and number of photos", preferredStyle: .alert)
        let choosePaper = UIAlertAction(title: choosPaperTitle, style: .default) {
            [weak ac, weak self] action in
            
            guard let ac = ac else { return }

            
            let paperSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            
            let a4 = UIAlertAction(title: "A4 8.3 x 11.7 in", style: .default) { action in
                let a2Width = 2480
                let a2Height = 3505
                
                self?.paperSize = CGSize(width: a2Width, height: a2Height)
                self?.present(ac, animated: true)
            }
            let a5 = UIAlertAction(title: "A5 5.8 x 8.3 in", style: .default) { action in
                let a2Width = 1746
                let a2Height = 2480
                
                self?.paperSize = CGSize(width: a2Width, height: a2Height)
                self?.present(ac, animated: true)
            }
            let a6 = UIAlertAction(title: "A6 4.1 x 5.8 in", style: .default) { action in
                let a2Width = 1239
                let a2Height = 1746
                
                self?.paperSize = CGSize(width: a2Width, height: a2Height)
                self?.present(ac, animated: true)
            }
            
            
            paperSheet.addAction(a4)
            paperSheet.addAction(a5)
            paperSheet.addAction(a6)
            self?.present(paperSheet, animated: true)
        }
        
        //print controller
        let presentPrintController = UIAlertAction(title: "Print", style: .default){ [weak self] action in
            guard let self = self else { return }
            let printController = UIPrintInteractionController.shared
            printController.delegate = self
            printController.showsPaperSelectionForLoadedPapers = true
            let printInfo = UIPrintInfo.printInfo()
            
            printController.printInfo = printInfo
            let  changedImg = self.imageResize(croppingImageView: img, viewSize: self.paperSize)

            printController.printingItem = changedImg
            printController.present(animated: true, completionHandler: nil)


        }
        
        ac.addAction(choosePaper)
//        ac.addAction(UIAlertAction)
        ac.addAction(presentPrintController)
        present(ac, animated: true)


        
    }
    
    
    
    func imageResize(croppingImageView: UIImageView, viewSize: CGSize) -> UIImage {
        
        let imageWidth: Double = sizeArr[0].width
        let imageHeight: Double = sizeArr[0].height
        let newView = UIView()
        newView.frame.size = viewSize
        let columns: Int = Int(viewSize.width / ((CGFloat(imageWidth)) + 30))
        let rows: Int = Int(viewSize.height / ((CGFloat(imageHeight)) + 30))
        
        for column in 0..<columns {
            for row in 0..<rows {
                let img = UIImageView.init(image: croppingImageView.image)
                img.frame = CGRect(x: (Double(column) * imageWidth) + Double(column * 60) , y: ((Double(row) * imageHeight)) + Double(row * 60), width: imageWidth, height: imageHeight)
                
                newView.addSubview(img)
            }
        }
        
        let renderedImage = newView.asImage()
        return renderedImage
        
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
