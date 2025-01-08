//
//  EmployeeTC.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 05/01/25.
//

import UIKit
import CoreData

class DepartmentTC: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    func updateData(_ department: Department) {
        nameLabel.text = department.name
    }
}
