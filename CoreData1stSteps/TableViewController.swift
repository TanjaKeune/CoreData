//
//  TableViewController.swift
//  CoreData1stSteps
//
//  Created by Tanja Keune on 7/29/17.
//  Copyright © 2017 SUGAPP. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultController:NSFetchedResultsController<Notebook>!
    
    var moc:NSManagedObjectContext!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        setuoFetchedResultsController()
    }
    
    func setuoFetchedResultsController () {
        
        let notebookRequest:NSFetchRequest<Notebook> = Notebook.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        notebookRequest.sortDescriptors = [sortDescriptor]
        
      //  let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: notebookRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return fetchedResultController.sections!.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }

        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let notebookObject = fetchedResultController.object(at: indexPath)
        cell.textLabel?.text = notebookObject.title
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Change Notebook", message: "Enter new Title", preferredStyle: .alert)
        alertController.addTextField { (textfield:UITextField) in
            textfield.placeholder = "New Notebook Title"
        }
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
            
            let textfield = alertController.textFields?.first
            let notebookObject = self.fetchedResultController.object(at: indexPath)
            notebookObject.title = textfield!.text
            
            do {
                try! self.moc.save()

            }
            
        }))
    
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let notebookObject = fetchedResultController.object(at: indexPath)
            notebookObject.managedObjectContext?.delete(notebookObject)
            
            do {
                try! moc.save()
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .delete {
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        } else if type == .update {
            self.configureCell(indexPath: indexPath!)
        }
    }
    
    func configureCell (indexPath:IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        let notebookObject = self.fetchedResultController.object(at: indexPath)
        
        cell?.textLabel?.text = notebookObject.title
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
