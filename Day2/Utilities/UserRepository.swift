//
//  UserRepository.swift
//  Day2
//
//  Created by P090MMCTSE016 on 19/10/23.
//

import Foundation
import CoreData

private let userCoreData = "User"

class UserRepository: NSObject{
    
    func insertIntoCoreData(
        appDelegate: AppDelegate,
        id: Int,
        name: String,
        salary: Int,
        onSuccess: @escaping()->Void,
        onFailed: @escaping()->Void
    ){
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: userCoreData, in: managedContext)
        
        let insertData = NSManagedObject(entity: userEntity!, insertInto: managedContext)
        insertData.setValue(id, forKey: "id")
        insertData.setValue(name, forKey: "name")
        insertData.setValue(salary, forKey: "salary")
        
        do{
            try managedContext.save()
            onSuccess()
        }catch let err{
            print(err)
            onFailed()
        }
    }
    
    
    func readData(
            appDelegate: AppDelegate,
            onSuccess: @escaping([UserModel]) -> Void,
            onError: @escaping(String) -> Void){
                
        var tempUserData: [UserModel] = []
        
        let managedContext = appDelegate.persistentContainer.viewContext
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
            
            onSuccess(tempUserData)
        }catch let err{
            print(err)
            onError("Error bro")
        }
    }
    
    func editData(
        appDelegate: AppDelegate,
        id: Int,
        name: String,
        salary: Int,
        onSuccess: @escaping() -> Void,
        onFailed: @escaping() -> Void
    ) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: userCoreData, in: managedContext)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: userCoreData)
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let dataToUpdate = result[0] as! NSManagedObject
            dataToUpdate.setValue(name, forKey: "name")
            dataToUpdate.setValue(salary, forKey: "salary")
            
            try managedContext.save()
            onSuccess()
        }catch let err{
            print(err)
            onFailed()
        }
    }
    
    func deleteData(
            appDelegate: AppDelegate,
            id: Int,
            onSuccess: @escaping()-> Void,
            onFailure: @escaping()-> Void
    ) {
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: userCoreData)
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", String(id))
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let dataToUpdate = result[0] as! NSManagedObject
            managedContext.delete(dataToUpdate)
            
            try managedContext.save()
            onSuccess()
        }catch let err{
            print(err)
            onFailure()
        }
    }
}
