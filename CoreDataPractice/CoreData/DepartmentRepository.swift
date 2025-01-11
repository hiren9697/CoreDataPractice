//
//  DepartmentRepository.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 10/01/25.
//

import Foundation
import CoreData

class DepartmentRepository {
    func fetchDepartments() -> [Department]? {
        // Define the fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Department")
        do {
            // Execute the fetch request
            let nsManagedObjects = try PersistentStorage.shared.context.fetch(fetchRequest)
            guard let departments = nsManagedObjects as? [Department] else {
                print("Could not cast managed objects to department")
                return nil
            }
            return departments
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
}
