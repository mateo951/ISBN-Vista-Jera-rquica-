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
    
    var test = ""
    var test1 = ""
    
    func configureView() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        bookTitle.text = test
        print(test)
        if test == bookTitle {
            authors.text = datosLibros[0].authors
            
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
