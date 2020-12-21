//
//  CropController.swift
//  passportPhoto
//
//  Created by Tigran on 12/20/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit
import CropViewController
import TOCropViewController

class CropController: UIViewController, CropViewControllerDelegate {

    var croppingImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let image = croppingImage {
            print("passed")
            let cropController = CropViewController(croppingStyle: .default, image: image)
            cropController.delegate = self
            present(cropController, animated: true)
        }
        
          
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
