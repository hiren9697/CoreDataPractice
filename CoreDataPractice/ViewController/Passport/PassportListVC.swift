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
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let createPassportFormVC = mainStoryboard.instantiateViewController(withIdentifier: "CreatePassportFormVC") as? CreatePassportFormVC else {
            return
        }
        createPassportFormVC.modalPresentationStyle = .overFullScreen
        present(createPassportFormVC, animated: false , completion: nil)
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

