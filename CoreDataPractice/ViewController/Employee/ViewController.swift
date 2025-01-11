//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 05/01/25.
//

import UIKit
import CoreData

// MARK: - VC
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var employees: [Employee] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
        refreshEmployeeList()
    }
}

// MARK: - IBAction
extension ViewController {
    @IBAction func btnAddTap() {
        // presentAddEmployeeAlert()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createEmployeeVC = mainStoryboard.instantiateViewController(withIdentifier: "CreateEmployeeVC") as! CreateEmployeeVC
        present(createEmployeeVC, animated: true)
    }
}

// MARK: - Helper
extension ViewController {
    private func setupInitialUI() {
        tableView.register(UINib(nibName: "EmployeeTC", bundle: Bundle.main),
                           forCellReuseIdentifier: "EmployeeTC")
    }
    
    private func presentAddEmployeeAlert() {
        let alert = UIAlertController(title: "Add Employee", message: "Enter the name of the employee to save.", preferredStyle: .alert)
        
        // Add a text field to the alert for entering the employee name
        alert.addTextField { textField in
            textField.placeholder = "Employee Name"
        }
        
        // Add a "Save" action
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let employeeName = textField.text,
                  !employeeName.isEmpty else {
                print("Employee name is empty")
                return
            }
            self.saveEmployee(withName: employeeName)
        }
        
        // Add a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    private func refreshEmployeeList() {
        employees = fetchEmployees() ?? []
        tableView.reloadData()
    }
}

// MARK: - Database helper
extension ViewController {
    func fetchEmployees() -> [Employee]? {
        
        // Define the fetch request
        let repository = EmployeeRepository()
        return repository.fetchEmployees()
    }
    
    private func saveEmployee(withName name: String) {
        let employee = Employee(context: PersistentStorage.shared.context)
        employee.name = name
        PersistentStorage.shared.saveContext()
        refreshEmployeeList()
    }
}

// MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTC", for: indexPath) as! EmployeeTC
        cell.updateData(employees[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}

