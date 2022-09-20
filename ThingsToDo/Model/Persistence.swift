//
//  Persistence.swift
//  ThingsToDo
//
//  Created by Kosei Ban on 2022-09-16.
//

import CoreData

struct PersistenceController {
    //MARK: - PersistenceController
    static let shared = PersistenceController()
    
    //MARK: - PersistanceContainer
    let container: NSPersistentContainer

    //MARK: - Initialization(Load the persistant store)
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "ThingsToDo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    //MARK: - PreView
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = "Sample Task No\(i)"
            newItem.completion = false
            newItem.id = UUID()
        }
        do {
            try viewContext.save()
        } catch {
           
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
