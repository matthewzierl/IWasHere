//
//  GlobeView.swift
//  IWasHere
//
//  Created by Matthew Zierl on 5/13/24.
//  Copyright © 2024 matthewzierl.org. All rights reserved.
//

import UIKit

class GlobeView: UIViewController {
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Create a label
            let label = UILabel()
            label.text = "Hello, Globe!"
            label.textAlignment = .center
            label.frame = CGRect(x: 50, y: 200, width: 300, height: 50)
            
            // Add the label to the view
            view.addSubview(label)
        }
}
