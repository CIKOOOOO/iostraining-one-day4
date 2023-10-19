//
//  APIService.swift
//  Day2
//
//  Created by P090MMCTSE016 on 19/10/23.
//

import Foundation
import Alamofire

private let urlEmployee = "https://dummy.restapiexample.com/api/v1/employees"

class APIService: NSObject{
    func fetchEmployees(
        onSuccess: @escaping ([Employee]) -> Void,
        onError: @escaping (Error?) -> Void
    ){
        let urlConvertible: URLConvertible = urlEmployee
        let responses = AF.request(urlConvertible)
        
        responses.response{
            responseData in
            if let responseData = responseData.data{
                do {
                    let result = try JSONDecoder().decode(EmployeeResponse.self, from: responseData)
                    debugPrint(result)
                    DispatchQueue.main.async {
                        onSuccess(result.data!)
                    }
                } catch let jsonErr {
                    print("Error Serialization json:", jsonErr)
                }
            }
        }
        
    }
}
