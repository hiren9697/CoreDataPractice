//
//  DepartmentListVC.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 06/01/25.
//

import UIKit
import CoreData

// MARK: - VC
class PassportListVC: ParentVC {
    @IBOutlet weak var tableView: UITableView!
    
    weak var passportIDTF: UITextField?
    weak var datePickerTF: UITextField?
    weak var employeeTF: UITextField?
    weak var saveButton: UIAlertAction?
    var enteredPassportID: String?
    var selectedDateOfIssue: Date?
    var selectedEmployee: Employee?
    lazy var employeePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    var passports: [Passport] = []
    var employees: [Employee]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
        refreshPassportList()
    }
}

// MARK: - IBAction
extension PassportListVC {
    @IBAction func btnAddTap() {
        employees = EmployeeRepository().fetchEmployees()
        presentAddPassportAlert()
    }
}

// MARK: - Helper
extension PassportListVC {
    private func setupInitialUI() {
        tableView.register(UINib(nibName: "PassportTC", bundle: Bundle.main),
                           forCellReuseIdentifier: "PassportTC")
    }
    
    private func refreshPassportList() {
        passports = fetchPassports() ?? []
        tableView.reloadData()
    }
}

// MARK: - Alert helper method
extension PassportListVC {
    private func presentAddPassportAlert() {
        let alert = UIAlertController(title: "Add Passport", message: "Enter the details of the passport to save.", preferredStyle: .alert)
        
        // 1. Add a text field to the alert for entering the passport ID
        alert.addTextField {[weak self] textField in
            guard let strongSelf = self else {
                return
            }
            textField.addTarget(strongSelf, action: #selector(strongSelf.handlePassportIDEditingChange(_:)), for: .editingChanged)
            textField.placeholder = "Passport ID"
            textField.returnKeyType = .next
        }
        
        // 2. Add a text field to the alert for selecting date of issue
        alert.addTextField {[weak self] textField in
            guard let strongSelf = self else { return }
            strongSelf.datePickerTF = textField
            textField.placeholder = "Date of issue"
            strongSelf.addToolbarWithNextButton(to: textField)
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.addTarget(strongSelf, action: #selector(strongSelf.dateChanged), for: .valueChanged)
            
            textField.inputView = datePicker
        }
        
        // 3. Add a text field to select person
        alert.addTextField {[weak self] textField in
            guard let strongSelf = self else { return }
            strongSelf.employeeTF = textField
            textField.placeholder = "Select Employee (Optional)"
            textField.inputView = strongSelf.employeePicker
            strongSelf.addToolbarWithDoneButton(to: textField)
        }
        
        // 4. Add a "Save" action
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let departmentName = textField.text,
                  !departmentName.isEmpty else {
                print("Passport ID name is empty")
                return
            }
        }
        self.saveButton = saveAction
        saveAction.isEnabled = false
        alert.addAction(saveAction)
        
        // 5. Add a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // 6. Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    /// Adds toolbar with next button on `Date of Issue` text field
    /// Next button tap makes `Select Person` text field first responder
    func addToolbarWithNextButton(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(dateOffIssueNextAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, nextButton]
        textField.inputAccessoryView = toolbar
    }

    /// Action for `Next` button in toolbar of text field `Date of Issue`
    @objc func dateOffIssueNextAction() {
        employeeTF?.becomeFirstResponder()
    }
    
    /// Adds toolbar with done button on `Select Employee` text field
    /// Next button tap makes `Select Employee` text field first responder
    func addToolbarWithDoneButton(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(selectEmployeeDoneAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, nextButton]
        textField.inputAccessoryView = toolbar
    }
    
    /// Action for `Done` button in toolbar of text field `Select Employee`
    @objc func selectEmployeeDoneAction() {
        employeeTF?.resignFirstResponder()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: sender.date)
        datePickerTF?.text = dateString
        selectedDateOfIssue = sender.date
        updateSaveButtonStatus()
    }
    
    @objc func handlePassportIDEditingChange(_ textField: UITextField) {
        enteredPassportID = textField.text
        updateSaveButtonStatus()
    }
    
    private func updateSaveButtonStatus() {
        guard let enteredPassportID = enteredPassportID,
              let _ = selectedDateOfIssue else {
            saveButton?.isEnabled = false
            return
        }
        saveButton?.isEnabled = !enteredPassportID.isEmpty
    }
}

// MARK: - Database helper
extension PassportListVC {
    func fetchPassports() -> [Passport]? {
        // Define the fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Passport")
        do {
            // Execute the fetch request
            let nsManagedObjects = try PersistentStorage.shared.context.fetch(fetchRequest)
            guard let passports = nsManagedObjects as? [Passport] else {
                print("Could not cast managed objects to department")
                return nil
            }
            return passports
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    private func savePassport(withID id: String, date: Date) {
//        let department = Department(context: PersistentStorage.shared.context)
//        department.name = name
//        PersistentStorage.shared.saveContext()
//        refreshDepartmentList()
    }
}

// MARK: - PickerViewDataSource
extension PassportListVC: UIPickerViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let employees = employees else {
            return 0
        }
        return employees.count
    }
}

// MARK: - PickerViewDelegate
extension PassportListVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        employees?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        employeeTF?.text = employees?[row].name
        selectedEmployee = employees?[row]
    }
}

// MARK: - TableView DataSource
extension PassportListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        passports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassportTC", for: indexPath) as! PassportTC
        cell.updateData(passports[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension PassportListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}

