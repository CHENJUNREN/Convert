//
//  Persistence.swift
//  Convert
//
//  Created by Chenjun Ren on 2022/2/13.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer
    
    let queue: OperationQueue

    private init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Convert")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { (storeDescription, error) in
            print(storeDescription.description)
            if let error = error as NSError? {
                print("‼️‼️‼️ Unresolved error \(error), \(error.userInfo)")
            }
        }
        // set up queue to perform database wirte operation
        queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
    }
    
    func enqueue(content: @escaping (NSManagedObjectContext) -> Void) {
        queue.addOperation {
            let backgroundContext = container.newBackgroundContext()
            backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            backgroundContext.performAndWait {
                content(backgroundContext)
                // save if needed
                if backgroundContext.hasChanges {
                    do {
                        try backgroundContext.save()
                    } catch {
                        print("‼️‼️‼️ Error: [message: \(error.localizedDescription)]")
                    }
                }
            }
        }
    }
}
