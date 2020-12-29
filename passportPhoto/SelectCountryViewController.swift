//
//  SelectCountryViewController.swift
//  passportPhoto
//
//  Created by Tigran on 12/30/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit

class SelectCountryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath)
        cell.textLabel?.text = "hello \(indexPath.row)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let svc = storyboard?.instantiateViewController(withIdentifier: "selectDocType") as? DocTypeViewController {
            self.present(svc, animated: true)
        }
    }

    
    

}
