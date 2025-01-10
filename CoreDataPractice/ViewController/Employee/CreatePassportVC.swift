//
//  CreatePassportVC.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 10/01/25.
//

import UIKit

class CreateEmployeeVC: UIViewController {
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var containerViewProfilePicture: UIView!
    @IBOutlet weak var imageViewProfilePicture: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDepartment: UITextField!
    @IBOutlet weak var tfPassport: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - IBAction
extension CreateEmployeeVC {
    @IBAction func btnSaveTapped(_ sender: Any) {
        
    }
    
    @IBAction func btnProfilePictureTapped(_ sender: Any) {
        
    }
}

// MARK: - UI helper method(s)
extension CreateEmployeeVC {
    private func setupInitialUI() {
        containerViewProfilePicture.layer.cornerRadius = containerViewProfilePicture.frame.height / 2
        containerViewProfilePicture.layer.masksToBounds = true
    }
}

// MARK: - Database Helper(s)
extension CreateEmployeeVC {
    
}
