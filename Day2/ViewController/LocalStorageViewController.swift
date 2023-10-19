//
//  LocalStorageViewController.swift
//  Day2
//
//  Created by P090MMCTSE016 on 19/10/23.
//

import UIKit
import CoreData

private let userDataCell = "userDataCell"
private let userCoreData = "User"

class LocalStorageViewController: UIViewController{
  
    @IBOutlet weak var tcUserData: UITableView!
    
    var arrUser: [UserModel] = []
    
    var viewModel: UserViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        tcUserData.register(UINib(
            nibName: "UserDataTableCell",
            bundle: nil
        ), forCellReuseIdentifier: userDataCell)
        
        tcUserData.dataSource = self
        tcUserData.delegate = self
        
        self.arrUser = self.readData()
        
        viewModel = UserViewModel()
        viewModel.setAppDelegate(appDelegate: appDelegate)
        
        viewModel.bindDataToVC = {
            self.tcUserData.reloadData()
        }
        viewModel.fetchData()
    }
    

    @IBAction func btnTambah(_ sender: Any) {
        showingPopUpAddNew()
    }
}

extension LocalStorageViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userDataCell, for: indexPath) as! UserDataTableCell
        cell.setValue(user: viewModel.userArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showEditPopUp(user: viewModel.userArr[indexPath.row], index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let user = viewModel.userArr[indexPath.row]
        if (editingStyle == .delete) {
//            deleteData(id: user.id, name: user.name, index: indexPath.row)
//            self.tcUserData.reloadData()
            
            viewModel.deleteData(id: user.id, index: indexPath.row)
        }
    }
    
    func showEditPopUp(user: UserModel, index: Int){
        let alert = UIAlertController(title: "New Employee", message: "Fill the form below to add new employee", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {tf in
            tf.text = "\(user.id)"
            tf.isUserInteractionEnabled = false
        })
        
        alert.addTextField(configurationHandler: {tf in
            tf.text = user.name
        })
        
        alert.addTextField(configurationHandler: {tf in
            tf.text = String(user.salary)
        })
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: {
            action in
            if alert.textFields![0].text!.isEmpty || alert.textFields![1].text!.isEmpty {
                let warning = UIAlertController(title: "Warning", message: "Fill all the textfields", preferredStyle: .alert)
                warning.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(warning, animated: true)
            }else{
//                
//                self.editData(id: Int(alert.textFields![0].text!) ?? 0, name: alert.textFields![1].text!, salary: Int(alert.textFields![2].text!) ?? 0)
                self.viewModel.updateData(user: UserModel(id: Int(alert.textFields![0].text!) ?? 0, name: alert.textFields![1].text!, salary: Int(alert.textFields![2].text!) ?? 0), index: index)
                let success = UIAlertController(title: "Success", message: "Data employee edited", preferredStyle: .alert)
                success.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(success, animated: true)
                self.arrUser = self.readData()
                self.tcUserData.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
    }
    
}

extension LocalStorageViewController{
    func insertIntoCoreData(id: Int, name: String, salary: Int){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: userCoreData, in: managedContext)
        
        let insertData = NSManagedObject(entity: userEntity!, insertInto: managedContext)
        insertData.setValue(id, forKey: "id")
        insertData.setValue(name, forKey: "name")
        insertData.setValue(salary, forKey: "salary")
        
        do{
            try managedContext.save()
        }catch let err{
            print(err)
        }
    }
    
    func readData() -> [UserModel] {
        var tempUserData: [UserModel] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: userCoreData, in: managedContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: userCoreData)
        
        do{
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            result.forEach{
                user in
                tempUserData.append(UserModel(id: user.value(forKey: "id") as! Int
                                         , name: user.value(forKey: "name") as! String
                                              , salary: user.value(forKey: "salary") as! Int
                                        ))
            }
        }catch let err{
            print(err)
        }
        
        return tempUserData
    }
    
    func editData(id: Int, name: String, salary: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: userCoreData, in: managedContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: userCoreData)
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let dataToUpdate = result[0] as! NSManagedObject
            dataToUpdate.setValue(name, forKey: "name")
            dataToUpdate.setValue(salary, forKey: "salary")
//            dataToUpdate.setValue(id, forKey: "id")
            
            try managedContext.save()
        }catch let err{
            print(err)
        }
    }
    
    func deleteData(id: Int, name: String, index: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
//        let userEntity = NSEntityDescription.entity(forEntityName: userCoreData, in: managedContext)
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: userCoreData)
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let dataToUpdate = result[0] as! NSManagedObject
            managedContext.delete(dataToUpdate)
            
            try managedContext.save()
            arrUser.remove(at: index)
        }catch let err{
            print(err)
        }
    }
    
}

extension LocalStorageViewController {
    func showingPopUpAddNew(){
        let alert = UIAlertController(title: "New Employee", message: "Fill the form below to add new employee", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "Id"
        })
        
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "Name"
        })
        
        alert.addTextField(configurationHandler: {tf in
            tf.placeholder = "Salary"
        })
        
        alert.addAction(UIAlertAction(title: "Tambah", style: .default, handler: {
            action in
            if alert.textFields![0].text!.isEmpty || alert.textFields![1].text!.isEmpty || alert.textFields![2].text!.isEmpty {
                let warning = UIAlertController(title: "Warning", message: "Fill all the textfields", preferredStyle: .alert)
                warning.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(warning, animated: true)
            }else{
                
//                self.insertIntoCoreData(id: Int(alert.textFields![0].text!) ?? 0, name: alert.textFields![1].text!, salary: Int(alert.textFields![2].text!) ?? 0)
                
                self.viewModel.insertDataTo(user: UserModel(id: Int(alert.textFields![0].text!) ?? 0, name: alert.textFields![1].text!, salary: Int(alert.textFields![2].text!) ?? 0))
                
                let success = UIAlertController(title: "Success", message: "Data employee added", preferredStyle: .alert)
                success.addAction(UIAlertAction(title: "Dismiss", style: .default))
                self.present(success, animated: true)
                self.arrUser = self.readData()
                self.tcUserData.reloadData()
            }
        }))
        
        self.present(alert, animated: true)
        
    }
}
