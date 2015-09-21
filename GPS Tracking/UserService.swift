//
//  UserAPI.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/5/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation

class UserService : ServiceBase {
    //User Login
<<<<<<< HEAD
    func login(userName userName: String, password: String, completion: (response: User?) -> ()){
        var user: User? = nil
        let url = getServiceURL(ServiceURL.Login) + "/" + userName + "/" + password
        print(url)
        Alamofire.manager.request(.GET, url, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                println(request)
                println(response)
                println(jsonData)
=======
    func login(#userName: String, password: String, completion: (response: User?) -> ()){
        var user: User? = nil
        let url = getServiceURL(ServiceURL.Login) + "/" + userName + "/" + password
        Alamofire.manager.request(.GET, url, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                    
                } else {
                    let data = JSON(jsonData!)
                    
                    if let success = data[JSONTags.SUCCESS.rawValue].int {
                        if success == 1 {
                            user = User()
                            user!.userId = data["Userid"].int64Value
                            user!.fullName = data["Name"].stringValue
                            user!.loginToken = data[JSONTags.TOKEN.rawValue].stringValue
                         } else {
                            self.errorCode = data[JSONTags.ERROR_CODE.rawValue].intValue
                            self.errorMessage = data[JSONTags.ERROR_MESSAGE.rawValue].stringValue
                        }
                    }
                    else {
                        self.errorCode = 404
                        self.errorMessage = "Service Connection failed! Please try again."
                    }
                }
                completion(response: user)
            }
    }
    
    //Create User
    func createUser(user: User, completion: (response: User?) -> ()) {
        var userResult: User? = nil
        let url = getServiceURL(ServiceURL.CreateUser)
        let parameters = [
            "username": user.userName,
            "password": user.password,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "address": user.address,
            "city": user.city,
            "state": user.state,
            "zip": user.zip,
            "phone": user.phone,
            "email": user.email
        ]
        
        Alamofire.manager.request(.POST, url, parameters: parameters,encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                } else {
                    let data = JSON(jsonData!)
                    let rootTag = "create_user_infoResult"
                    
                    if let success = data[rootTag][JSONTags.SUCCESS.rawValue].int {
                        if success == 1 {
                            userResult = User()
                            userResult!.updateInfo(user)
                            userResult!.loginToken = data[rootTag][JSONTags.TOKEN.rawValue].stringValue
                        } else {
                            self.errorCode = data[rootTag][JSONTags.ERROR_CODE.rawValue].intValue
                            self.errorMessage = data[rootTag][JSONTags.ERROR_MESSAGE.rawValue].stringValue
                        }
                    } else {
                        self.errorCode = data[rootTag][JSONTags.ERROR_CODE.rawValue].intValue
                        self.errorMessage = data[rootTag][JSONTags.ERROR_MESSAGE.rawValue].stringValue
                    }
                }
                completion(response: userResult)
        }
    }
    
    //Get User Info
    func getUserInfo(loginToken: String, completion: (response: User?) -> ()) {
        var user: User? = nil
        let url = getServiceURL(ServiceURL.UserInfo) + "/" + loginToken

        Alamofire.manager.request(.GET, url, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                    
                } else {
                    let data = JSON(jsonData!)
                    
                    if let success = data[JSONTags.SUCCESS.rawValue].int {
                        if success == 1 {
                            user = User()
                            user!.firstName = data["FirstName"].stringValue;
                            user!.lastName = data["LastName"].stringValue;
                            user!.address = data["Address"].stringValue;
                            user!.city = data["City"].stringValue;
                            user!.state = data["State"].stringValue;
                            user!.zip = data["Zip"].stringValue;
                            user!.phone = data["Phone"].stringValue;
                            user!.email = data["Email"].stringValue;
                        } else {
                            self.errorCode = data[JSONTags.ERROR_CODE.rawValue].intValue
                            self.errorMessage = data[JSONTags.ERROR_MESSAGE.rawValue].stringValue
                        }
                    }
                    else {
                        self.errorCode = 404
                        self.errorMessage = "Service Connection failed! Please try again."
                    }
                }
                completion(response: user)
        }
    }
    
    //Update User Info
    func updateUserInfo(user: User, completion: (response: Bool) -> ()) {
        var successResult = false
        let url = getServiceURL(ServiceURL.UserInfo)
        let parameters = [
            "token": user.loginToken,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "address": user.address,
            "city": user.city,
            "state": user.state,
            "zip": user.zip,
            "phone": user.phone,
            "email": user.email
        ]
        
        Alamofire.manager.request(.POST, url, parameters:  parameters, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                    
                } else {
                    let data = JSON(jsonData!)
                    let rootTag = "update_user_infoResult"
                    
                    if let success = data[rootTag][JSONTags.SUCCESS.rawValue].int {
                        if success == 1 {
                            successResult = true
                        } else {
                            self.errorCode = data[rootTag][JSONTags.ERROR_CODE.rawValue].intValue
                            self.errorMessage = data[rootTag][JSONTags.ERROR_MESSAGE.rawValue].stringValue
                        }
                    }
                    else {
                        self.errorCode = 404
                        self.errorMessage = "Service Connection failed! Please try again."
                    }
                }
                completion(response: successResult)
        }
    }
}