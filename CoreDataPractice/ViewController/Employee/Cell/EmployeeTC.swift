//
//  EmployeeTC.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 05/01/25.
//

import UIKit
import CoreData

class EmployeeTC: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var passportLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!

    func updateData(_ employee: Employee) {
        nameLabel.text = employee.displayNameText
        passportLabel.text = employee.passportIDText
        departmentLabel.text = employee.departmentText
    }
}
