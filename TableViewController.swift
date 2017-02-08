//
//  TableViewController.swift
//  ISBN(Vista Jerárquica)
//
//  Created by Mateo Villagomez on 2/4/16.
//  Copyright © 2016 Mateo Villgomez. All rights reserved.
//

import UIKit
import CoreData

var Libros = [AnyObject]()

class TableViewController: UITableViewController {
    
    @IBOutlet var BooksTable: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "Libro")
        do {
            Libros = try context().fetch(fetchRequest)
        } catch {}
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let destination = segue.destination as? DetailViewController {
                let path = (self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row
                let arr = Libros[path!]
                destination.titleBook = arr.value(forKey: "nombreLibro")! as! String
                destination.author = arr.value(forKey: "autorLibro")! as! String
                let test = arr.value(forKey: "imagenLibro") as! Data?
                if  test != nil {
                    destination.imageData = arr.value(forKey: "imagenLibro")! as? Data
                }
            }
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Libros.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = Libros[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = book.value(forKey: "nombreLibro")! as? String
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            // remove the deleted item from the model
            context().delete(Libros[(indexPath as NSIndexPath).row] as! NSManagedObject)
            Libros.remove(at: (indexPath as NSIndexPath).row)
            do {
                try context().save()
            } catch {print(error)}
            // Deleting item from Table View
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
