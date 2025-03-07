//
//  CreatePassportFormVC.swift
//  CoreDataPractice
//
//  Created by Hirenkumar Fadadu on 08/01/25.
//

import UIKit

class CreatePassportFormVC: UIViewController {
    // Data model
    enum Mode {
        case create
        case edit(Passport)
    }
    struct PassportFormData {
        let passportID: String
        let dateOfIssue: Date
        let selectedEmployee: Employee?
    }
    typealias Completion = (_ mode: Mode, _ data: PassportFormData) -> Void
    
    // UI components
    weak var passportIDTF: UITextField?
    weak var datePickerTF: UITextField?
    weak var employeeTF: UITextField?
    weak var saveButton: UIAlertAction?
    lazy var employeePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    // Variables to save entered data
    var employees: [Employee]?
    var enteredPassportID: String?
    var selectedDateOfIssue: Date?
    var selectedEmployee: Employee?
    
    // Completion handler to pass data on click of `Save` button
    var mode: Mode!
    var completionHandler: Completion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employees = EmployeeRepository().fetchEmployees()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presentAddPassportAlert()
    }
}

// MARK: - Alert
extension CreatePassportFormVC {
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
            if case let .edit(existingPassport) = strongSelf.mode {
                textField.text = existingPassport.id
            }
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
            datePicker.maximumDate = Date()
            datePicker.addTarget(strongSelf, action: #selector(strongSelf.dateChanged), for: .valueChanged)
            textField.inputView = datePicker
            if case let .edit(existingPassport) = strongSelf.mode {
                datePicker.date = existingPassport.dateOfIssue
                strongSelf.dateChanged(datePicker)
            }
        }
        
        // 3. Add a text field to select person
        alert.addTextField {[weak self] textField in
            guard let strongSelf = self else { return }
            strongSelf.employeeTF = textField
            textField.placeholder = "Select Employee (Optional)"
            textField.inputView = strongSelf.employeePicker
            strongSelf.addToolbarWithDoneButton(to: textField)
            if case let .edit(existingPassport) = strongSelf.mode,
               let existingEmployee = existingPassport.toEmployee {
                if let currentEmployeeIndex = strongSelf.employees?.firstIndex(of: existingEmployee) {
                    strongSelf.employeePicker.selectRow(currentEmployeeIndex, inComponent: 0, animated: false)
                    textField.text = existingEmployee.name
                }
            }
        }
        
        // 4. Add a "Save" action
        let saveAction = UIAlertAction(title: "Save", style: .default) {[weak self] _ in
            guard let strongSelf = self,
                  let enteredPassportID = strongSelf.enteredPassportID,
                  let selectedDateOfIssue = strongSelf.selectedDateOfIssue else {
                print("Passport ID name is empty")
                return
            }
            let formData = PassportFormData(passportID: enteredPassportID,
                                            dateOfIssue: selectedDateOfIssue,
                                            selectedEmployee: strongSelf.selectedEmployee)
            strongSelf.completionHandler?(strongSelf.mode, formData)
            strongSelf.dismiss(animated: true)
        }
        self.saveButton = saveAction
        saveAction.isEnabled = false
        alert.addAction(saveAction)
        
        // 5. Add a "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            self.dismiss(animated: true)
        })
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
        if selectedDateOfIssue == nil {
            if let datePicker = datePickerTF?.inputView as? UIDatePicker {
                dateChanged(datePicker)
            }
        }
        employeeTF?.becomeFirstResponder()
    }
    
    /// Adds toolbar with done button on `Select Employee` text field
    /// Done button tap makes `Select Employee` resigns first responder
    func addToolbarWithDoneButton(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(selectEmployeeCancelAction))
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(selectEmployeeDoneAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, nextButton]
        textField.inputAccessoryView = toolbar
    }
    
    /// Action for `Done` button in toolbar of text field `Select Employee`
    @objc func selectEmployeeDoneAction() {
        if let pickerView = employeeTF?.inputView as? UIPickerView {
            employeeTF?.text = employees?[pickerView.selectedRow(inComponent: 0)].name
            selectedEmployee = employees?[pickerView.selectedRow(inComponent: 0)]
        }
        employeeTF?.resignFirstResponder()
    }
    
    /// Action for `Cancel` button in toolbar of text field `Select Employee`
    @objc func selectEmployeeCancelAction() {
        employeeTF?.resignFirstResponder()
    }
   
    /// Handles date changes in date picker
    /// Updates `selectionDateOfIssue` and text in `datePickerTF`
    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let dateString = formatter.string(from: sender.date)
        datePickerTF?.text = dateString
        selectedDateOfIssue = sender.date
        updateSaveButtonStatus()
    }
    
    /// Handles text changes in passport ID text field
    @objc func handlePassportIDEditingChange(_ textField: UITextField) {
        enteredPassportID = textField.text
        updateSaveButtonStatus()
    }
    
    /// Enable or disable save button based on selected issue date and passport ID
    private func updateSaveButtonStatus() {
        guard let enteredPassportID = enteredPassportID,
              let _ = selectedDateOfIssue else {
            saveButton?.isEnabled = false
            return
        }
        saveButton?.isEnabled = !enteredPassportID.isEmpty
    }
}

// MARK: - PickerViewDataSource
extension CreatePassportFormVC: UIPickerViewDataSource {
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
extension CreatePassportFormVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        employees?[row].name
    }
}
