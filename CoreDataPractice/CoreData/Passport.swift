//
//  Passport.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 06/01/25.
//

import CoreData

@objc(Passport)
public class Passport: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var dateOfIssue: Date
    @NSManaged public var toEmployee: Employee?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: dateOfIssue)
    }
    var displayIDText: String {
        "ID: \(id)"
    }
    var displayDateOfIssue: String {
        "Date of issue: \(formattedDate)"
    }
    var displayEmployeeText: String {
        if let toEmployee = toEmployee {
            return "Employee: \(toEmployee.name)"
        } else {
            return "Employee: -"
        }
    }
}
