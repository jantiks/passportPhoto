//
//  ViewController.swift
//  passportPhoto
//
//  Created by Tigran on 12/20/20.
//  Copyright © 2020 Tigran. All rights reserved.
//

import UIKit

class ImportController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tabBarArray = tabBarController?.tabBar.items {
            for i in 1..<tabBarArray.count {
                tabBarArray[i].isEnabled = false
            }
        }
    }


}

