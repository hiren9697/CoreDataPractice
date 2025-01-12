//
//  DepartmentRepository.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 10/01/25.
//

import Foundation
import CoreData

class DepartmentRepository {
    let coreDataStack = CoreDataStack()
    
    func fetchDepartments() -> [Department]? {
        // Define the fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Department")
        do {
            // Execute the fetch request
            let nsManagedObjects = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            guard let departments = nsManagedObjects as? [Department] else {
                print("Could not cast managed objects to department")
                return nil
            }
            for department in departments {
                print("Department: \(department.name)")
            }
            return departments
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
