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
        cell.textLabel?.text = "\(aspecRatios[indexPath.row].name) \(aspecRatios[indexPath.row].width):\(aspecRatios[indexPath.row].height) \(aspecRatios[indexPath.row].sizeType)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemBlue
        cell?.selectedBackgroundView = backgroundView
        cell?.textLabel?.textColor = .white
        
        if let image = currentImage {
            
            let cropController = Mantis.cropViewController(image: image)
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
        let img = cropped
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
