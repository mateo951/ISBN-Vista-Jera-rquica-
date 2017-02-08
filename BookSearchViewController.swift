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
        let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
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
    @IBAction func Search(_ sender: UITextField) {
        // Verifying if data is already stored
        let fetchRequest = NSFetchRequest(entityName: "Libro")
        do {
            let libroEntidad = try context().fetch(fetchRequest)
            for i in libroEntidad {
                let test = i.value(forKey: "isbnLibro") as? String
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
                let nuevoLibro = NSEntityDescription.insertNewObject(forEntityName: "Libro", into: context())
                // Insert new data from book
                nuevoLibro.setValue(resultadosLibro?.0, forKey: "nombreLibro")
                nuevoLibro.setValue(resultadosLibro?.1, forKey: "autorLibro")
                nuevoLibro.setValue(sender.text!, forKey: "isbnLibro")
                if resultadosLibro?.2 != nil {
                    let imageData = NSData(data: UIImagePNGRepresentation(resultadosLibro!.2!)!) as Data
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
    
    func internetSearch(_ termino: String) -> (String, String, UIImage?)? {
        var bookTitle: String?
        var bookAuthor: String?
        var bookCover: UIImage?
        let userInput: String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + textField.text! + ""
        
        if let url = URL(string: "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + textField.text! + "") {
            let numbers = CharacterSet.decimalDigits
            let phrase = userInput
            let range = phrase.rangeOfCharacter(from: numbers)
            
            // Accepting only numbers 
            if let range = range {
                if let data = try? Data(contentsOf: url) {
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
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
                                            let imageURL = URL(string: imageURLS)
                                            let imageData = try? Data(contentsOf: imageURL!)
                                            if imageData != 0 {
                                                if let Image = UIImage(data: imageData!) {
                                                    self.imageView.image = Image
                                                    self.imageView.isHidden = false
                                                    bookCover = Image
                                                    return (bookTitle!, bookAuthor!, bookCover!)
                                                }
                                            } else {
                                                self.imageView.isHidden = true
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
    func labelConfiguration(_ label: UILabel) {
        label.textColor = UIColor(colorLiteralRed: 185, green: 158, blue: 115, alpha: 1)
        label.text = "No se encontró el libro"
    }
    func inputError(_ label: UILabel) {
        label.textColor = UIColor(colorLiteralRed: 185, green: 158, blue: 115, alpha: 1)
        label.text = "Por favor , ingrese datos validos"
    }
}
