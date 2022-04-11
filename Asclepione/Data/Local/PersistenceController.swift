//
//  PersistenceController.swift
//  Asclepione
//
//  Created by Marc Jowett on 04/03/2022.
//

import Foundation
import CoreData

final class PersistenceController {
    static var shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
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
