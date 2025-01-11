//
//  Employee.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 05/01/25.
//

import UIKit
import CoreData

// 1. Code gen: Manual / None
@objc(Employee)
public class Employee: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var profilePicture: Data
    @NSManaged public var toDepartment: Department
    @NSManaged public var toPassport: Passport?
    lazy var profilePictureImage: UIImage = {
        UIImage(data: profilePicture)!
    }()

    var displayNameText: String {
        "Name: \(name)"
    }
    var passportIDText: String {
        "Passport ID: \(toPassport?.id ?? "-")"
    }
    var departmentText: String {
        "Department: \(toDepartment.name)"
    }
}
