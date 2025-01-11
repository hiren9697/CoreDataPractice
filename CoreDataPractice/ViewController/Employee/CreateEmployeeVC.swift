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
    private let pickerView: UIPickerView = UIPickerView()
    private var imagePicker: UIImagePickerController!
    
    var passports: [Passport] = []
    var departments: [Department] = []
    let departmentPicker = UIPickerView()
    let passportPicker = UIPickerView()
    var selectedProfilePicture: UIImage? {
        didSet {
            imageViewProfilePicture.image = selectedProfilePicture
        }
    }
    var selectedDepartment: Department? {
        didSet {
            tfDepartment.text = selectedDepartment?.name
        }
    }
    var selectedPassport: Passport? {
        didSet {
            tfPassport.text = selectedPassport?.id
        }
    }
    var completion: (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDepartments()
        fetchPassports()
        setupInitialUI()
    }
}

// MARK: - IBAction
extension CreateEmployeeVC {
    @IBAction func btnSaveTapped(_ sender: Any) {
        guard let profilePictureData = selectedProfilePicture?.jpegData(compressionQuality: 0.5),
        let department = selectedDepartment else { return }
        let employee = Employee(context: PersistentStorage.shared.context)
        employee.profilePicture = profilePictureData
        employee.name = tfName.text!
        employee.toDepartment = department
        employee.toPassport = selectedPassport
        PersistentStorage.shared.saveContext()
        completion()
        dismiss(animated: true)
    }
    
    @IBAction func btnProfilePictureTapped(_ sender: Any) {
        PermissionManager.shared.requestPhotoPermission {[weak self] status, isGranted in
            guard let _ = self else { return }
            if isGranted {
                DispatchQueue.main.async {[weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.imagePicker.sourceType = .photoLibrary
                    strongSelf.present(strongSelf.imagePicker, animated: true)
                }
            }
        }
    }
}

// MARK: - UI helper method(s)
extension CreateEmployeeVC {
    private func setupInitialUI() {
        // Profile picture
        containerViewProfilePicture.layer.borderColor = UIColor.lightGray.cgColor
        containerViewProfilePicture.layer.borderWidth = 1
        containerViewProfilePicture.layer.cornerRadius = containerViewProfilePicture.frame.height / 2
        containerViewProfilePicture.layer.masksToBounds = true
        // Image Picker
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        // Picker view
        pickerView.delegate = self
        pickerView.dataSource = self
        tfDepartment.inputView = pickerView
        tfPassport.inputView = pickerView
        // Add toolbar to text fields
        addToolbarWithNextButton(to: tfDepartment)
        addToolbarWithDoneButton(to: tfPassport)
    }
    
    /// Adds toolbar with next button on `Department` text field
    /// Next button tap makes `Passport` text field first responder
    func addToolbarWithNextButton(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(departmentNextAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, nextButton]
        textField.inputAccessoryView = toolbar
    }
    
    @objc func departmentNextAction() {
        if selectedDepartment == nil {
            selectedDepartment = departments[pickerView.selectedRow(inComponent: 0)]
        }
        tfPassport.becomeFirstResponder()
    }
    
    /// Adds toolbar with done button on `Passport` text field
    /// Next button tap makes `Passport` text field first responder
    func addToolbarWithDoneButton(to textField: UITextField) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(selectPassportCancelAction))
        let nextButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(selectPassportDoneAction))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [cancelButton, flexibleSpace, nextButton]
        textField.inputAccessoryView = toolbar
    }
    
    @objc func selectPassportCancelAction() {
        tfPassport.resignFirstResponder()
    }
    
    @objc func selectPassportDoneAction() {
        selectedPassport = passports[pickerView.selectedRow(inComponent: 0)]
        tfPassport.resignFirstResponder()
    }
}

// MARK: - TextField Delegate
extension CreateEmployeeVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfDepartment || textField == tfPassport {
            pickerView.selectRow(0, inComponent: 0, animated: false)
            pickerView.reloadAllComponents()
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfName {
            tfDepartment.becomeFirstResponder()
        }
        return true
    }
}

// MARK: - Database Helper(s)
extension CreateEmployeeVC {
    private func fetchDepartments() {
        let repository = DepartmentRepository()
        departments = repository.fetchDepartments() ?? []
    }
    
    private func fetchPassports() {
        let repository = PassportRepository()
        passports = repository.fetchPassports() ?? []
    }
}

// MARK: - PickerViewDataSource
extension CreateEmployeeVC: UIPickerViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if tfDepartment.isFirstResponder {
            return departments.count
        } else if tfPassport.isFirstResponder {
            return passports.count
        }
        return 0
    }
}

// MARK: - PickerViewDelegate
extension CreateEmployeeVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if tfDepartment.isFirstResponder {
            return departments[row].name
        } else if tfPassport.isFirstResponder {
            return passports[row].id
        }
        return "-"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if tfDepartment.isFirstResponder {
            selectedDepartment = departments[row]
        }
    }
}

// MARK: - Image Picker
extension CreateEmployeeVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            selectedProfilePicture = image
        }
    }
}
