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
    
    override func viewDidAppear(animated: Bool) {
        let fetchRequest = NSFetchRequest(entityName: "Libro")
        do {
            Libros = try context().executeFetchRequest(fetchRequest)
        } catch {}
        self.tableView.reloadData()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let destination = segue.destinationViewController as? DetailViewController {
                let path = self.tableView.indexPathForSelectedRow?.row
                let arr = Libros[path!]
                destination.titleBook = arr.valueForKey("nombreLibro")! as! String
                destination.author = arr.valueForKey("autorLibro")! as! String
                let test = arr.valueForKey("imagenLibro") as! NSData?
                if  test != nil {
                    destination.imageData = arr.valueForKey("imagenLibro")! as? NSData
                }
            }
        }
    }
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Libros.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let book = Libros[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = book.valueForKey("nombreLibro")! as? String
        return cell
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            // remove the deleted item from the model
            context().deleteObject(Libros[indexPath.row] as! NSManagedObject)
            Libros.removeAtIndex(indexPath.row)
            do {
                try context().save()
            } catch {print(error)}
            // Deleting item from Table View
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}
