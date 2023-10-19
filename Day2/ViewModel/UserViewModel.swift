//
//  UserViewModel.swift
//  Day2
//
//  Created by P090MMCTSE016 on 19/10/23.
//

import Foundation


class UserViewModel: NSObject{
    
    private var userRepository: UserRepository!
    private var appDelegate: AppDelegate!
    
    private(set) var userArr: [UserModel] = []{
        didSet{
            self.bindDataToVC()
        }
    }
    
    var bindDataToVC: () -> () = {}
    
    override init(){
        userRepository = UserRepository()
    }
    
    func setAppDelegate(appDelegate: AppDelegate){
        self.appDelegate = appDelegate
    }
    
    func fetchData(){
        userRepository.readData(appDelegate: self.appDelegate) { arrUserData in
            self.userArr = arrUserData
        } onError: { data in
            print(data)
        }
    }
    
    func insertDataTo(user: UserModel) {
        userRepository.insertIntoCoreData(appDelegate: self.appDelegate, id: user.id, name: user.name, salary: user.salary) {
            self.userArr.append(user)
        } onFailed: {
            print("Error when insert data")
        }
    }
    
    func updateData(user: UserModel, index: Int) {
        userRepository.editData(appDelegate: self.appDelegate, id: user.id, name: user.name, salary: user.salary) {
            self.userArr[index] = user
        } onFailed: {
            print("Error when update data")
        }
    }
    
    func deleteData(id: Int, index: Int){
        userRepository.deleteData(appDelegate: appDelegate, id: id) {
            self.userArr.remove(at: index)
        } onFailure: {
            print("Error when update data")
        }
    }
}
