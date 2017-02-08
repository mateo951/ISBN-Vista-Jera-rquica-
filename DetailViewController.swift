//
//  DetailViewController.swift
//  ISBN(Vista Jerárquica)
//
//  Created by Mateo Villagomez on 2/29/16.
//  Copyright © 2016 Mateo Villgomez. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    var titleBook: String = ""
    var author: String = ""
    var imageData: Data? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookTitle.text = "Titulo:   \(titleBook)"
        authors.text = "Autor:  \(author)"
        
        if imageData != nil {
            let image = UIImage(data: imageData!)
            bookImage.image = image
        }
    }
}
    
