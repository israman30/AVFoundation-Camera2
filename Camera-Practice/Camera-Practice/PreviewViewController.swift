//
//  PreviewViewController.swift
//  Camera-Practice
//
//  Created by Israel Manzo on 8/15/17.
//  Copyright © 2017 Israel Manzo. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let imagePhoto = photo {
            imageView.image = imagePhoto
        }
        
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
 
}
