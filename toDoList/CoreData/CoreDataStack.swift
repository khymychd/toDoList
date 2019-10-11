//
//  CoreDataStack.swift
//  toDoList
//
//  Created by Dima Khymych on 11.10.2019.
//  Copyright © 2019 Dima Khymych. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    var conteiner : NSPersistentContainer {
        let container = NSPersistentContainer (name: "toDoList")
        container.loadPersistentStores { (description, error) in
            guard error == nil else{
                print("Error: \(error ?? "Error" as! Error)")
                return
            }
        }
        
        return container
    }
    
    
    var managedContext: NSManagedObjectContext {
        return conteiner.viewContext
    }
    
}
