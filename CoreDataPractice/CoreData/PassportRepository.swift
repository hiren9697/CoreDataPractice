//
//  PassportRepository.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 10/01/25.
//

import Foundation
import CoreData

class PassportRepository {
    let coreDataStack = CoreDataStack()
    
    func fetchPassports() -> [Passport]? {
        // Define the fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Passport")
        do {
            // Execute the fetch request
            let nsManagedObjects = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            guard let passports = nsManagedObjects as? [Passport] else {
                print("Could not cast managed objects to department")
                return nil
            }
            return passports
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
