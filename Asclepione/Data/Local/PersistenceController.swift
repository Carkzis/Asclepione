//
//  PersistenceController.swift
//  Asclepione
//
//  Created by Marc Jowett on 04/03/2022.
//

import Foundation
import CoreData

/**
 Controller that allows access to the NSPersistentContainer that itself includes all objects needed to represent a functioning Core Data stack.
 */
final class PersistenceController {
    static var shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
        /*
         If inMemory is set to true, in memory data storage is used,
         as opposed to the local data storage of a device.
         */
        if inMemory {
            PersistenceController.shared = self
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }

    }
    
    /**
     Saveas the newly created entries into the CoreData database, or rolls the changes back if the attempt fails.
     */
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Error saving to database, changes rolled back.")
            }
        }
    }
}
