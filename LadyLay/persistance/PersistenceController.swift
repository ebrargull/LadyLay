//
//  PersistenceController.swift
//  DailyApp
//
//  Created by Ebrar Gül on 20.06.2024.
//

import Foundation
import CoreData

struct PersistenceController2 {
    static let shared = PersistenceController2()
    
    let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "LadyLay")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func getByItems(query: String, handler: @escaping ([Item]) -> Void) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)
        ]
        
        if !query.isEmpty {
            //let p1 = NSPredicate(format: "%K BEGINSWITH[cd] %@", #keyPath(Item.title), query)
            //let p2 = NSPredicate(format: "%K BEGINSWITH[cd] %@", #keyPath(Item.detail), query)
            //let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [p1, p2])
            //request.predicate = predicate
        }
        
        do {
            let results = try viewContext.fetch(request)
            handler(results)
        } catch let error {
            print("Fetch error: \(error.localizedDescription)")
            handler([])
        }
    }
}
