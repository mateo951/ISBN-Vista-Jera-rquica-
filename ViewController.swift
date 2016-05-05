//
//  ViewController.swift
//  ISBN(Vista Jerárquica)
//
//  Created by Mateo Villagomez on 2/4/16.
//  Copyright © 2016 Mateo Villgomez. All rights reserved.
//

import UIKit
import CoreData

var datosLibros = [bookData]()

// var imagenesLibro = [imagesData]()

var imageFound = Bool()

struct bookData {
    
    var title: String
    var author: String
    var image: UIImage
    
    init(title: String, author: String, image: UIImage) {
        self.title = title
        self.author = author
        self.image = image
    }
}

class ViewController: UIViewController {
    
    @IBOutlet var ViewC: UIView!
    
    var wasSuccesfull = false
    
    //var context: NSManagedObjectContext? = nil
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var authorTextView: UITextView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Estableciendo el valor de la variable "contexto"(contexto de CoreData)
        //self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
    }

    @IBAction func Search(sender: UITextField) {
        
        textView.text = ""
        authorTextView.text = ""
        errorLabel.text = ""
        imageView.hidden = true
        /*
        // COREDATA STORING
        // Verifying if data is already stored
        let libroEntidad = NSEntityDescription.entityForName("Libro", inManagedObjectContext: self.context!)
        let petition = libroEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petLibro", substitutionVariables: ["isbnLibro" : sender.text!])
        do {
            let libroEntidad2 = try self.context?.executeFetchRequest(petition!)
            if (libroEntidad2?.count > 0) {
                sender.text = nil
                return
            }
        } catch {}
         */
        let (title1, author1, cover1) = (internetSearch(sender.text!))
        let libro = bookData(title: title1, author: author1, image: cover1)
        print(libro)
        datosLibros.append(libro)
        print(datosLibros)
    }
    
    func internetSearch(termino: String) -> (String, String, UIImage) {
        
        var bookTitle = String()
        var bookAuthor = String()
        var bookCover = UIImage()
        
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
                                            bookTitle = Title
                                            bookAuthor = Author
                                        })
                                    }
                                }
                                if let covers = isbn["cover"] as? NSDictionary {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        let imageURLS = covers["medium"] as! NSString as String
                                        let imageURL = NSURL(string: imageURLS)
                                        let imageData = NSData(contentsOfURL: imageURL!)
                                        if (imageData != 0) {
                                            imageFound = true
                                            if let Image = UIImage(data: imageData!) {
                                                self.imageView.image = Image
                                                bookCover = Image
                                            }
                                        }
                                        self.imageView.hidden = false
                                    })
                                    
                                } else {
                                    self.imageView.hidden = true
                                    imageFound = false
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
        return (bookTitle, bookAuthor, bookCover)
    }
}