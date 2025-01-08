//
//  DepartmentListVC.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 06/01/25.
//

import UIKit
import CoreData

// MARK: - VC
class DepartmentListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var departments: [Department] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
        refreshDepartmentList()
    }
}

// MARK: - IBAction
extension DepartmentListVC {
    @IBAction func btnAddTap() {
        presentAddDepartmentAlert()
    }
}

// MARK: - Helper
extension DepartmentListVC {
    private func setupInitialUI() {
        tableView.register(UINib(nibName: "DepartmentTC", bundle: Bundle.main),
                           forCellReuseIdentifier: "DepartmentTC")
    }
    
    private func presentAddDepartmentAlert() {
        let alert = UIAlertController(title: "Add Department", message: "Enter the name of the department to save.", preferredStyle: .alert)
        
        // Add a text field to the alert for entering the department name
        alert.addTextField { textField in
            textField.placeholder = "Department Name"
        }
        
        // Add a "Save" action
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let departmentName = textField.text,
                  !departmentName.isEmpty else {
                print("Department name is empty")
                return
            }
            self.saveDepartment(withName: departmentName)
        }
        
        // Add a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    private func refreshDepartmentList() {
        departments = fetchDepartments() ?? []
        tableView.reloadData()
    }
}

// MARK: - Database helper
extension DepartmentListVC {
    func fetchDepartments() -> [Department]? {
        /*
        // Go to this path in finder and in 'Library/Application Support' you will fild sqlite file of core data
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(path.first!)
         */
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
    
    private func saveDepartment(withName name: String) {
        let department = Department(context: PersistentStorage.shared.context)
        department.name = name
        PersistentStorage.shared.saveContext()
        refreshDepartmentList()
    }
}

// MARK: - TableView DataSource
extension DepartmentListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        departments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DepartmentTC", for: indexPath) as! DepartmentTC
        cell.updateData(departments[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension DepartmentListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

