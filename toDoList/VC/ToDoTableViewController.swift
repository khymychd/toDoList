//
//  ToDoTableViewController.swift
//  toDoList
//
//  Created by Dima Khymych on 11.10.2019.
//  Copyright © 2019 Dima Khymych. All rights reserved.
//

import UIKit
import CoreData

class ToDoTableViewController: UITableViewController {

    //MARK: - Properties
    
    var resultsController:NSFetchedResultsController<ToDo>!
    let coreDataStack = CoreDataStack()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Request
        let request:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        //Init
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController(
        fetchRequest: request,
        managedObjectContext: coreDataStack.managedContext,
        sectionNameKeyPath: nil,
        cacheName: nil)
        
        
        resultsController.delegate = self
        
        //Fetch
        
        do {
        
            try resultsController.performFetch()
       
        }catch{
            
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return resultsController.sections?[section].numberOfObjects ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)

        // Configure the cell...
        
        let todo = resultsController.object(at: indexPath)
        cell.textLabel?.text = todo.title

        return cell
    }
 
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion ) in
            //TODO: delete todo
            
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            
            do{
                try self.resultsController.managedObjectContext.save()
            } catch {
                completion(false)
            }
            
            
            completion(true)
        }
        
       // action.image = UIImage(named: "trash")
        action.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let action = UIContextualAction(style: .destructive, title: "Chek") { (action, view, completion ) in
            //TODO: delete todo
            
            let todo = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(todo)
            
            do{
                try self.resultsController.managedObjectContext.save()
            } catch {
                completion(false)
            }
            
            completion(true)
        }
        
        //action.image = UIImage(named: "check")
        action.backgroundColor = UIColor.green
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "ShowAddToDo", sender: tableView.cellForRow(at: indexPath))
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddToDoViewController{
            vc.managedContext = resultsController.managedObjectContext
        }
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddToDoViewController{
            vc.managedContext = resultsController.managedObjectContext
            
            if let indexPath = tableView.indexPath(for: cell) {
                let todo = resultsController.object(at: indexPath)
                vc.todo = todo
            }
        }
    }
}

extension ToDoTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath{
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
           
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                let todo = resultsController.object(at: indexPath)
                cell.textLabel?.text = todo.title
            }
            
        default:
            break
        }
    }
}
