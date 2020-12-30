//
//  DocTypeViewController.swift
//  passportPhoto
//
//  Created by Tigran on 12/30/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit
import Mantis


class DocTypeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CropViewControllerDelegate {
    
    @IBOutlet var backButton: UIButton!
    var currentImage: UIImage?
    var sizeArr = [(width: Double, height: Double)]()
    var aspecRatios = [(width: Double, height: Double, name: String, sizeType: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 20

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        aspecRatios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "docTypeCell", for: indexPath)
//        let type = aspecRatios[indexPath.row].name.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)
        
        cell.textLabel?.text = "\(aspecRatios[indexPath.row].name) \(aspecRatios[indexPath.row].width):\(aspecRatios[indexPath.row].height) \(aspecRatios[indexPath.row].sizeType)"
        cell.textLabel?.numberOfLines = 0
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemBlue
        cell?.selectedBackgroundView = backgroundView
        cell?.textLabel?.textColor = .white
        
        
        
        if let image = currentImage {
            
            let width = aspecRatios[indexPath.row].width
            let height = aspecRatios[indexPath.row].height
            
            sizeArr = [(width * 118, height * 118)]
            
            let cropController = Mantis.cropViewController(image: image)
            cropController.config.presetFixedRatioType = .alwaysUsingOnePresetFixedRatio(ratio: width / height)
            cropController.delegate = self
            
            present(cropController, animated: true)
           
            
        }
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
            timer in
            backgroundView.backgroundColor = .white
            cell?.selectedBackgroundView = backgroundView
            cell?.textLabel?.textColor = .black
        }
    }
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        dismiss(animated: true, completion: nil)
        if let svc = storyboard?.instantiateViewController(withIdentifier: "Export") as? ExportController {
            svc.croppedImage = cropped
            svc.sizeArr = sizeArr
            self.present(svc, animated: true)
        }
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
