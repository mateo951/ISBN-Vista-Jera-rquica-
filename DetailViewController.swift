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
    var image: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookTitle.text = titleBook
        self.authors.text = "Author/s:\(author)"
        if (image != nil) {
            let imageUrl = NSURL(string: image!)
            let imageData = NSData(contentsOfURL: imageUrl!)
            self.bookImage.image = UIImage(data: imageData!)
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
