//
//  CoreDataVC.swift
//  CoreD
//
//  Created by Vahid Sayad on 5/22/16.
//  Copyright © 2016 Vahid Sayad. All rights reserved.
//

import UIKit
import CoreData


class CoreDataVC: UITableViewController {

    var dataSource = [NSManagedObject]()
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedObjectContext = appDelegate.managedObjectContext
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let product = dataSource[indexPath.row]
        cell.textLabel?.text = product.valueForKey("name") as? String
        print(product.debugDescription)

        return cell
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    func loadData(){
        let request = NSFetchRequest(entityName: "Products")
        
        do {
            let result = try managedObjectContext.executeFetchRequest(request)
            dataSource = result as! [NSManagedObject]
            tableView.reloadData()
        } catch {
            fatalError("Error in retreving Products items")
        }
    }
    
    //MARK: Actions
    @IBAction func addAction(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "لیست کالا", message: "اصافه کردن کالا", preferredStyle: UIAlertControllerStyle.Alert)
        
        let addAction = UIAlertAction(title: "اصافه کن", style: UIAlertActionStyle.Default) { (action: UIAlertAction) in
            let textField = alert.textFields?.first

            let entity = NSEntityDescription.entityForName("Products", inManagedObjectContext: self.managedObjectContext)
            let product = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedObjectContext)
            product.setValue(textField?.text, forKey: "name")
            
            do {
                try self.managedObjectContext.save()
            } catch {
                fatalError("Error in saving data to Core Data")
            }
            
            self.loadData()
        }
        
        let cancelAction = UIAlertAction(title: "لغو", style: UIAlertActionStyle.Default) { (cancel: UIAlertAction) in
            
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) in
            
        }
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true) { 
            
        }
    }

}
