//
//  ViewController.swift
//  ISBN(Vista Jerárquica)
//
//  Created by Mateo Villagomez on 2/4/16.
//  Copyright © 2016 Mateo Villgomez. All rights reserved.
//

import UIKit
import CoreData

var datosLibros = [BookData]()
var datosLibros2 = [BookDataNoImage]()

// var imagenesLibro = [imagesData]()

var imageFound = Bool()

struct BookData {
    
    var title: String
    var author: String
    var image: UIImage?
}

struct BookDataNoImage {
    
    var title: String
    var author: String
}

class ViewController: UIViewController {
    
    @IBOutlet var ViewC: UIView!
    
    var wasSuccesfull = false
    
    //var context: NSManagedObjectContext? = nil
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func Search(sender: UITextField) {
        
        titleLabel.text = ""
        authorLabel.text = ""
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
        let dataRetrived = (internetSearch(sender.text!))
        if dataRetrived != nil {
            let (title1, author1, cover1) = dataRetrived!
            let libro = BookData(title: title1, author: author1, image: cover1)
            datosLibros.append(libro)
            print(datosLibros)
        }
    }
    
    func internetSearch(termino: String) -> (String, String, UIImage)? {
        
        var bookTitle: String?
        var bookAuthor: String?
        var bookCover: UIImage?
        var userInput: String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + textField.text! + ""
        
        if let url = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + textField.text! + "") {
            let numbers = NSCharacterSet.decimalDigitCharacterSet()
            let phrase = userInput
            let range = phrase.rangeOfCharacterFromSet(numbers)
            
            // Accepting only numbers 
            if let test = range {
                if let data = NSData(contentsOfURL: url) {
                    do{
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
                        
                        if jsonResult!.count > 0 {
                            if let isbn = jsonResult!["ISBN:\(self.textField.text!)"] as? NSDictionary {
                                if let covers = isbn["cover"] as? NSDictionary {
                                    let imageURLS = covers["medium"] as! NSString as String
                                    let imageURL = NSURL(string: imageURLS)
                                    let imageData = NSData(contentsOfURL: imageURL!)
                                    if (imageData != 0) {
                                        imageFound = true
                                        if let Image = UIImage(data: imageData!) {
                                            self.imageView.image = Image
                                            self.imageView.hidden = false
                                            bookCover = Image
                                        }
                                    } else {
                                        self.imageView.hidden = true
                                        imageFound = false
                                        print("No se encontro Imagen")
                                    }
                                    if let authors = isbn["authors"] as? [[String: AnyObject]] {
                                        for author in authors {
                                            // Title
                                            let Title = isbn["title"] as! NSString as String
                                            titlesArray.append(Title)
                                            // Author
                                            let Author = author["name"] as! NSString as String
                                            self.titleLabel.text = "Titulo del libro: \(Title)"
                                            self.authorLabel.text = "Autor/es: \(Author)"
                                            bookTitle = Title
                                            bookAuthor = Author
                                            if imageFound == false {
                                                // Funcion(Titulo/Artistas) si no hay IMAGEN
                                                func noImage() -> (String, String) {
                                                    return (bookTitle!, bookAuthor!)
                                                }
                                                // TEST
                                                let (titulo, autor) = noImage()
                                                let libro = BookDataNoImage(title: titulo, author: autor)
                                                datosLibros2.append(libro)
                                                print(datosLibros2)
                                                return nil
                                            }
                                        }
                                    } else {
                                        self.errorLabel.text = "Libro no indentificado"
                                        return nil
                                    }
                                } else {
                                    if let authors = isbn["authors"] as? [[String: AnyObject]] {
                                        for author in authors {
                                            // Title
                                            let Title = isbn["title"] as! NSString as String
                                            titlesArray.append(Title)
                                            // Author
                                            let Author = author["name"] as! NSString as String
                                            self.titleLabel.text = "Titulo del libro: \(Title)"
                                            self.authorLabel.text = "Autor/es: \(Author)"
                                            bookTitle = Title
                                            bookAuthor = Author
                                            imageFound = false
                                            print(imageFound)
                                            if imageFound == false {
                                                // Funcion(Titulo/Artistas) si no hay IMAGEN
                                                func noImage() -> (String, String) {
                                                    return (bookTitle!, bookAuthor!)
                                                }
                                                // TEST
                                                let (titulo, autor) = noImage()
                                                let libro = BookDataNoImage(title: titulo, author: autor)
                                                datosLibros2.append(libro)
                                                print(datosLibros2)
                                                return nil
                                            }
                                        }
                                    } else {
                                        self.errorLabel.text = "Libro no encontrado"
                                        return nil
                                    }
                                }
                            } else if self.wasSuccesfull == false {
                                self.errorLabel.textColor = UIColor(colorLiteralRed: 185, green: 158, blue: 115, alpha: 1)
                                self.errorLabel.text = "No se encontró la información - Inténtelo de nuevo"
                            }
                        }
                    } catch {
                        self.errorLabel.text = "Por favor, ingrese datos validos!"
                        return nil
                    }
                } else {
                    self.errorLabel.text = "Por favor, ingrese datos validos!"
                    return nil
                }
            } else {
                print("")
                self.errorLabel.text = "Por favor , ingrese datos validos"
                return nil
            }
        } else {
            self.errorLabel.text = "Por favor, ingrese datos validos!"
            return nil
        }
        print(titlesArray)
        return (bookTitle!, bookAuthor!, bookCover!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Estableciendo el valor de la variable "contexto"(contexto de CoreData)
        //self.context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
    }
}