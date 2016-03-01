//
//  ViewController.swift
//  ISBN(Vista Jerárquica)
//
//  Created by Mateo Villagomez on 2/4/16.
//  Copyright © 2016 Mateo Villgomez. All rights reserved.
//

import UIKit

var datosLibros = [savedData]()

struct savedData {
    
    var titles: String
    var authors: String
    
    init(titles: String, authors: String) {
        
        self.titles = titles
        self.authors = authors
        
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var ViewC: UIView!
    
    var wasSuccesfull = false
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var authorTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func Search(sender: UITextField) {
        
        textView.text = ""
        authorTextView.text = ""
        errorLabel.text = ""
        imageView.hidden = true
        
        let url = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + textField.text! + "")!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            if error != nil {
                self.errorLabel.text = "Libro no Identificado"
            } else {
                
                if let data = data {
                    do{
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
                        
                        if jsonResult!.count > 0 {
                            if let isbn = jsonResult!["ISBN:\(self.textField.text!)"] as? NSDictionary {
                                if let authors = isbn["authors"] as? [[String: AnyObject]] {
                                for author in authors {
                                // Fast Display (Updating UI)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                // Title
                                let Title = isbn["title"] as! NSString as String
                                // Adding Titles to (titlesArray)
                                titlesArray.append(Title)
                                // Author
                                let Author = author["name"] as! NSString as String
                                
                                self.textView.text = "Titulo del libro: \(Title)"
                                self.authorTextView.text = "Autor/es: \(Author)"
                                let SavedData = savedData(titles: Title, authors: Author)
                                datosLibros.append(SavedData)
                                    print(datosLibros)
                                })

                                /* // Another option
                                    if let title = isbn["title"] as? NSString */
                                }
                                }
                                if let covers = isbn["cover"] as? NSDictionary {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        let imageURLS = covers["medium"] as! NSString as String
                                        let imageURL = NSURL(string: imageURLS)
                                        let imageData = NSData(contentsOfURL: imageURL!)
                                        if (imageData != 0) {
                                            if let Image = UIImage(data: imageData!) {
                                                self.imageView.image = Image
                                            }
                                        }
                                        self.imageView.hidden = false
                                    })
                                } else { self.imageView.hidden = true
                                }
                            }
                        }   // Error if the city does not exist or the procces failed
                        else if self.wasSuccesfull == false {
                            // Giving color to the text
                            self.errorLabel.textColor = UIColor(colorLiteralRed: 185, green: 158, blue: 115, alpha: 1)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.errorLabel.text = "No se encontró la información - Inténtelo de nuevo"
                            })
                        }
                    } catch {
                    }
                }
            }
        }
        task.resume()
    }
    /*
    let SavedData = savedData(titles: self.busquedaTitulo(sender.text!), authors: self.busquedaAutor(sender.text!),images: self.busquedaImagen(sender.text!))
    datosLibros.append(SavedData)
    ViewC.reloadInputViews()
    
    sender.text = nil
    sender.resignFirstResponder()
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}