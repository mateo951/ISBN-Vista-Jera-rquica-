//
//  BookSearchViewController.swift
//  ISBN(Vista Jerárquica)
//
//  Created by Mateo Villagomez on 2/4/16.
//  Copyright © 2016 Mateo Villgomez. All rights reserved.
//
import UIKit
import CoreData

    func context() -> NSManagedObjectContext {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        return context
    }

class BookSearchViewController: UIViewController {
    var libroExistente = false
    // Retreive the managedObjectContext from AppDelegate
    @IBOutlet var ViewC: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func Search(sender: UITextField) {
        // Verifying if data is already stored
        let fetchRequest = NSFetchRequest(entityName: "Libro")
        do {
            let libroEntidad = try context().executeFetchRequest(fetchRequest)
            for i in libroEntidad {
                let test = i.valueForKey("isbnLibro") as? String
                if sender.text == test {
                    libroExistente = true
                    return errorLabel.text = "El isbn ingresado ya fue buscado!"
                } else {
                    libroExistente = false
                }
            }
        } catch {print("Error")}
        
        errorLabel.text = ""
        if libroExistente != true {
            let resultadosLibro = internetSearch(sender.text!)
            if resultadosLibro != nil {
                // Create a new managed object
                let nuevoLibro = NSEntityDescription.insertNewObjectForEntityForName("Libro", inManagedObjectContext: context())
                // Insert new data from book
                nuevoLibro.setValue(resultadosLibro?.0, forKey: "nombreLibro")
                nuevoLibro.setValue(resultadosLibro?.1, forKey: "autorLibro")
                nuevoLibro.setValue(sender.text!, forKey: "isbnLibro")
                if resultadosLibro?.2 != nil {
                    let imageData = NSData(data: UIImagePNGRepresentation(resultadosLibro!.2!)!)
                    nuevoLibro.setValue(imageData, forKey: "imagenLibro")
                }
                let saveError: NSError? = nil
                // Save the object to persistent store
                do {
                    try context().save()
                } catch {
                    print("Can't Save! \(saveError)")
                }
            }
        } 
    }
    
    func internetSearch(termino: String) -> (String, String, UIImage?)? {
        var bookTitle: String?
        var bookAuthor: String?
        var bookCover: UIImage?
        let userInput: String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + textField.text! + ""
        
        if let url = NSURL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + textField.text! + "") {
            let numbers = NSCharacterSet.decimalDigitCharacterSet()
            let phrase = userInput
            let range = phrase.rangeOfCharacterFromSet(numbers)
            
            // Accepting only numbers 
            if let range = range {
                if let data = NSData(contentsOfURL: url) {
                    do{
                        let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject]
                        if jsonResult!.count > 0 {
                            if let isbn = jsonResult!["ISBN:\(self.textField.text!)"] as? NSDictionary {
                                if let authors = isbn["authors"] as? [[String: AnyObject]] {
                                    for author in authors {
                                        // Title
                                        let Title = isbn["title"] as! NSString as String
                                        // Author
                                        let Author = author["name"] as! NSString as String
                                        self.titleLabel.text = "Titulo del libro: \(Title)"
                                        self.authorLabel.text = "Autor/es: \(Author)"
                                        bookTitle = Title
                                        bookAuthor = Author
                                        if let covers = isbn["cover"] as? NSDictionary {
                                            let imageURLS = covers["medium"] as! NSString as String
                                            let imageURL = NSURL(string: imageURLS)
                                            let imageData = NSData(contentsOfURL: imageURL!)
                                            if imageData != 0 {
                                                if let Image = UIImage(data: imageData!) {
                                                    self.imageView.image = Image
                                                    self.imageView.hidden = false
                                                    bookCover = Image
                                                    return (bookTitle!, bookAuthor!, bookCover!)
                                                }
                                            } else {
                                                self.imageView.hidden = true
                                                return (bookTitle!, bookAuthor!, nil)
                                            }
                                        } else {
                                            return (bookTitle!, bookAuthor!, nil)
                                        }
                                    }
                                } else {
                                    self.errorLabel.text = "Libro no identificado"
                                    return nil }
                            } else {
                                labelConfiguration(errorLabel) }
                        } else {
                            labelConfiguration(errorLabel)
                            return nil }
                    } catch {
                        inputError(errorLabel)
                        return nil }
                } else {
                    inputError(errorLabel) }
            } else {
                inputError(errorLabel)
                return nil }
        } else {
            inputError(errorLabel)
            return nil
        }
        return (bookTitle!, bookAuthor!, bookCover!)
    }
    func labelConfiguration(label: UILabel) {
        label.textColor = UIColor(colorLiteralRed: 185, green: 158, blue: 115, alpha: 1)
        label.text = "No se encontró el libro"
    }
    func inputError(label: UILabel) {
        label.textColor = UIColor(colorLiteralRed: 185, green: 158, blue: 115, alpha: 1)
        label.text = "Por favor , ingrese datos validos"
    }
}