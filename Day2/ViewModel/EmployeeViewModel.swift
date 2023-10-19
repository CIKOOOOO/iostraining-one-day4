//
//  EmployeeViewModel.swift
//  Day2
//
//  Created by P090MMCTSE016 on 19/10/23.
//

import Foundation

class EmployeeViewModel: NSObject {
    private var apiService: APIService!
    private(set) var employeeData: [Employee] = [] {
        didSet {
            self.bindDataToVC()
        }
    }
    
    var bindDataToVC: () -> () = {}
    
    override init() {
        super.init()
        apiService = APIService()
        
    }
    
    func fetchData(){
        apiService.fetchEmployees{
            employee in
            self.employeeData = employee
        } onError: { error in
            print(error ?? "Errror")
        }
        
    }
    
}
