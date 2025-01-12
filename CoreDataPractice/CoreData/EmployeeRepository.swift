//
//  EmployeeRepository.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 07/01/25.
//

import CoreData

class EmployeeRepository {
    let coreDataStack: CoreDataStack = CoreDataStack()
    
    func fetchEmployees() -> [Employee]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Employee")
        do {
            // Execute the fetch request
            let nsManagedObjects = try coreDataStack.managedObjectContext.fetch(fetchRequest)
            guard let employees = nsManagedObjects as? [Employee] else {
                print("Could not cast managed objects to employees")
                return nil
            }
            return employees
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
