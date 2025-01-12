//
//  CoreDataStack.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 11/01/25.
//

import CoreData

///*
final class CoreDataStack: NSObject {
    static let moduleName = "CoreDataPractice"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: Self.moduleName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var applicationDocumentDirectory: URL = {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let persistentStoreURL = self.applicationDocumentDirectory.appendingPathComponent("\(Self.moduleName).sqlite")
        do {
            try _ = coordinator.addPersistentStore(type: NSPersistentStore.StoreType(rawValue: NSSQLiteStoreType),
                                                   configuration: nil,
                                                   at: persistentStoreURL,
                                                   options: [
                                                    NSMigratePersistentStoresAutomaticallyOption: true,
                                                    NSInferMappingModelAutomaticallyOption: true
                                                   ])
        } catch {
            fatalError("Persistent store error: \(error)")
        }
        return coordinator
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Self.moduleName)
        container.loadPersistentStores(completionHandler: { _, error in
            if let error {
                fatalError("Failed to load persistent store: \(error)")
            }
        })
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        /*
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
         */
        persistentContainer.viewContext
    }()
    
    func saveMainContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("error in saving main context: \(error)")
            }
        }
    }
}
//*/

/*
class CoreDataStack {
    let persistentStorage: PersistentStorage = PersistentStorage.shared
    
    var managedObjectContext: NSManagedObjectContext {
        persistentStorage.context
    }
    
    func saveMainContext() {
        persistentStorage.saveContext()
    }
}

public class PersistentStorage {
    public static let shared = PersistentStorage()
    
    private init() {}
    
    lazy var context: NSManagedObjectContext = persistentContainer.viewContext
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataPractice")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
*/
