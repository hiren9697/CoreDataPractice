//
//  EmployeeTC.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 05/01/25.
//

import UIKit
import CoreData

class PassportTC: UITableViewCell {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateOfIssueLabel: UILabel!

    func updateData(_ passport: Passport) {
        idLabel.text = passport.id
        dateOfIssueLabel.text = passport.formattedDate
    }
}
