//
//  SelectCountryViewController.swift
//  passportPhoto
//
//  Created by Tigran on 12/30/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit
import SwiftSoup

class SelectCountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backButton: UIButton!
    var selectedImage: UIImage?
    var aspecRatios = [(width: Double, height: Double, name: String, sizeType: String)]()
    var countries = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 20
        

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        
        
        cell.textLabel?.text = countries[indexPath.row]
        
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
            for i in 0..<aspecRatios.count {
                if aspecRatios[i].name.lowercased().contains(countries[indexPath.row].lowercased()) {
                    svc.aspecRatios.append(aspecRatios[i])
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

    @IBAction func backtapped(_ sender: UIButton) {
            dismiss(animated: true, completion: nil)

    }
    
    

}
