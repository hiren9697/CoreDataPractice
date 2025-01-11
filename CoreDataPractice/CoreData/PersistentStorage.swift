//
//  PersistentStorage.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 05/01/25.
//

import CoreData

public class PersistentStorage {
    public static let shared = PersistentStorage()
    private let coreDataStack: CoreDataStack = CoreDataStack()
    
    private init() {}
    
    lazy var context: NSManagedObjectContext = coreDataStack.managedObjectContext
    
    func saveContext () {
        coreDataStack.saveMainContext()
    }
}
