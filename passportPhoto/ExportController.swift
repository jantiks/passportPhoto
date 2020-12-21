//
//  ExportController.swift
//  passportPhoto
//
//  Created by Tigran on 12/20/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit

class ExportController: UIViewController {

    var croppedImage: UIImage?
    
    
    @IBOutlet var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let image = croppedImage {
//            imageView.image = image
//        }
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let image = croppedImage {
            imageView.image = image
        }
    }
    

    

}
