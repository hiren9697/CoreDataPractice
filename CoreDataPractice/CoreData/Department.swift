//
//  Department.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 06/01/25.
//

import CoreData

@objc(Department)
public class Department: NSManagedObject {
    @NSManaged public var name: String
}
