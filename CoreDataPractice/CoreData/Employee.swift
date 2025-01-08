//
//  Employee.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 05/01/25.
//

import CoreData

/// Code gen
/// 1. Manual / None: - Need to create class for entities and declare properties of those classes manually
/// 2. Class Definition: - We don't need to write any files regarding core data entity classes, Xcode automatically generates 2 files:
/// One with class declaration that represents entities, but without any properties
/// Second with extension of that class with properties that represents attributes of entities
/// 3. Category / Extension: - We are responsible for creating class of class of entities, but without properties, Xcode generates one file:
/// File with extension of core data entity, which contains all properties of class

// 1. Code gen: Manual / None
@objc(Employee)
public class Employee: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var toPassport: Passport?
}


// 2. Code gen: Category / Extension
/*
 @objc(Employee)
 public class Employee: NSManagedObject {
 
 }
 */
