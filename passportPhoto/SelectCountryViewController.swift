//
//  SelectCountryViewController.swift
//  passportPhoto
//
//  Created by Tigran on 12/30/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit
import SwiftSoup
import Mantis

class SelectCountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CropViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backButton: UIButton!
    var selectedImage: UIImage?
    var aspecRatios = [(width: Double, height: Double, name: String, sizeType: String)]()
    var countries = [String]()
    var specified = ["United States", "Canada", "Australia", "Custom Size"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 20
        tableView.sectionIndexColor = .green
        

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return specified.count
        }
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = specified[indexPath.row]
        } else {
            cell.textLabel?.text = countries[indexPath.row]
        }
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .systemBlue
        cell?.selectedBackgroundView = backgroundView
        
        cell?.textLabel?.textColor = .white
        
        if let svc = storyboard?.instantiateViewController(withIdentifier: "selectDocType") as? DocTypeViewController {
            svc.currentImage = selectedImage
            
            if indexPath.section == 0 {
                switch cell?.textLabel?.text {
                case "Custom Size":
                    if let image = selectedImage {
                        let cropController = Mantis.cropViewController(image: image)
                        cropController.delegate = self
                        
                        present(cropController, animated: true)
                    }
                    
                default:
                    for i in 0..<aspecRatios.count {
                        if aspecRatios[i].name.lowercased().contains(specified[indexPath.row].lowercased()) {
                            svc.aspecRatios.append(aspecRatios[i])
                        }
                    }
                }
            } else {
                for i in 0..<aspecRatios.count {
                    if aspecRatios[i].name.lowercased().contains(countries[indexPath.row].lowercased()) {
                        svc.aspecRatios.append(aspecRatios[i])
                    }
                }
            }
            
            
            self.present(svc, animated: true)
        }
        
        
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {
            timer in
            backgroundView.backgroundColor = .white
            cell?.selectedBackgroundView = backgroundView
            cell?.textLabel?.textColor = .black
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        return "All"
    }
    
    func cropViewControllerDidCrop(_ cropViewController: CropViewController, cropped: UIImage, transformation: Transformation) {
        dismiss(animated: true, completion: nil)
        if let svc = storyboard?.instantiateViewController(withIdentifier: "Export") as? ExportController {
            svc.croppedImage = cropped
            svc.sizeArr = [(Double(transformation.maskFrame.width), Double(transformation.maskFrame.height))]
            

            self.present(svc, animated: true)
        }
    }
    
    func cropViewControllerDidCancel(_ cropViewController: CropViewController, original: UIImage) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func backtapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)

    }
    
    

}
