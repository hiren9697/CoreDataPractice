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
    
    var passports: [Passport] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
        refreshPassportList()
    }
}

// MARK: - IBAction
extension PassportListVC {
    @IBAction func btnAddTap() {
        presentFormVC(editPassport: nil)
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
    
    private func presentFormVC(editPassport: Passport?) {
        let mode: CreatePassportFormVC.Mode
        if let editPassport = editPassport {
            mode = .edit(editPassport)
        } else {
            mode = .create
        }
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let createPassportFormVC = mainStoryboard.instantiateViewController(withIdentifier: "CreatePassportFormVC") as? CreatePassportFormVC else {
            return
        }
        createPassportFormVC.modalPresentationStyle = .overFullScreen
        createPassportFormVC.mode = mode
        createPassportFormVC.completionHandler = {[weak self] (mode, formData) in
            guard let strongSelf = self else { return }
            switch mode {
            case .create:
                strongSelf.savePassport(id: formData.passportID, dateOfIssue: formData.dateOfIssue, employee: formData.selectedEmployee)
            case .edit(let passport):
                strongSelf.editPassport(existingPassportObject: passport,
                                        newID: formData.passportID,
                                        newDateOfIssue: formData.dateOfIssue,
                                        newEmployee: formData.selectedEmployee)
            }
        }
        present(createPassportFormVC, animated: false , completion: nil)
    }
}

// MARK: - Database helper
extension PassportListVC {
    private func fetchPassports() -> [Passport]? {
        PassportRepository().fetchPassports()
    }
    
    private func savePassport(id: String, dateOfIssue: Date, employee: Employee?) {
        let passport = Passport(context: PersistentStorage.shared.context)
        passport.id = id
        passport.dateOfIssue = dateOfIssue
        passport.toEmployee = employee
        PersistentStorage.shared.saveContext()
        refreshPassportList()
    }
    
    private func editPassport(existingPassportObject: Passport,
                              newID: String,
                              newDateOfIssue: Date,
                              newEmployee: Employee?) {
        existingPassportObject.id = newID
        existingPassportObject.dateOfIssue = newDateOfIssue
        existingPassportObject.toEmployee = newEmployee
        PersistentStorage.shared.saveContext()
        refreshPassportList()
    }
    
    private func deletePassport(at indexPath: IndexPath) {
        let passportToDelete = passports[indexPath.row]
        PersistentStorage.shared.context.delete(passportToDelete)
        PersistentStorage.shared.saveContext()
        passports.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let strongSelf = self else { return }
            strongSelf.deletePassport(at: indexPath)
            completionHandler(true) // Indicate the action was performed
        }
        deleteAction.backgroundColor = .red
        
        // Edit Action
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] _, _, completionHandler in
            guard let strongSelf = self else { return }
            strongSelf.presentFormVC(editPassport: strongSelf.passports[indexPath.row])
            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        
        // Combine Actions
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false // Prevent full swipe
        return configuration
    }
}

