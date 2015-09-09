//
//  DeviceService.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/7/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation

class DeviceService: ServiceBase {
    //send general
    func sendRequest(#loginToken: String, authToken: String, serial: String, commandType: Commands, completion: (response: Int)->()) {
        switch (commandType) {
        case Commands.LOCATE: //Locate
            self.locate(loginToken: loginToken, authToken: authToken, serial: serial) {transactionId in
                completion(response: transactionId)
            }
            break
            
        case Commands.ENABLE_STARTER: //Starter Enable
            self.enableStarter(loginToken: loginToken, authToken: authToken, serial: serial) {transactionId in
                completion(response: transactionId)
            }
            break
            
        case Commands.DISABLE_STARTER: //Starter Disable
            self.disableStarter(loginToken: loginToken, authToken: authToken, serial: serial) {transactionId in
                completion(response: transactionId)
            }
            break
            
        case Commands.ENABLE_LATE_PAYMENT: //Enable Late Payment
            self.enableBuzzer(loginToken: loginToken, authToken: authToken, serial: serial) {transactionId in
                completion(response: transactionId)
            }
            break
            
        case Commands.DISABLE_LATE_PAYMENT: //Disable Late Payment
            self.disableBuzzer(loginToken: loginToken, authToken: authToken, serial: serial) {transactionId in
                completion(response: transactionId)
            }
            break
        }
    }
    //Send Command
    private func sendCommand(url: String, _ loginToken: String, _ authToken: String, _ serial: String, _ resultTagName: String, completion: (response: Int) -> ()){
        var result:Int = -1
        
        let parameters = [
            "token": loginToken,
            "authtoken": authToken,
            "serial": serial
        ]
        
        Alamofire.manager.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                    
                } else {
                    let data = JSON(jsonData!)
                    
                    result = data[resultTagName]["TransactionId"].intValue
                    
                }
                completion(response: result)
        }
    }
    
    //Locate
    private func locate(#loginToken: String, authToken: String, serial: String, completion: (response: Int) -> ()){
        let url = getServiceURL(ServiceURL.Locate)
        sendCommand(url, loginToken, authToken, serial, "locateBySerialResult") {result in
            completion(response: result)
        }
    }
    
    //Enable Late Payment
    private func enableBuzzer(#loginToken: String, authToken: String, serial: String, completion: (response: Int) -> ()){
        let url = getServiceURL(ServiceURL.EnableLatePayment)
        sendCommand(url, loginToken, authToken, serial, "enableLatePaymentBySerialResult") {result in
            completion(response: result)
        }
    }
    
    //Disable Late Payment
    private func disableBuzzer(#loginToken: String, authToken: String, serial: String, completion: (response: Int) -> ()){
        let url = getServiceURL(ServiceURL.DisableLatePayment)
        sendCommand(url, loginToken, authToken, serial, "disableLatePaymentBySerialResult") {result in
            completion(response: result)
        }
    }
    
    //Enable Starter
    private func enableStarter(#loginToken: String, authToken: String, serial: String, completion: (response: Int) -> ()){
        let url = getServiceURL(ServiceURL.EnableStarter)
        sendCommand(url, loginToken, authToken, serial, "enableStarterBySerialResult") {result in
            completion(response: result)
        }
    }
    
    //Disable Starter
    private func disableStarter(#loginToken: String, authToken: String, serial: String, completion: (response: Int) -> ()){
        let url = getServiceURL(ServiceURL.DisableStarter)
        sendCommand(url, loginToken, authToken, serial, "disableStarterBySerialResult") {result in
            completion(response: result)
        }
    }
    
    //Check Command Status
    func checkCommandStatus(#authToken: String, transactionId: Int, completion: (response: CommandStatus?) -> ()){
        var commandStatus: CommandStatus? = nil
        
        let url = getServiceURL(ServiceURL.CommandStatus) + "/" + authToken + "/\(transactionId)"
        Alamofire.manager.request(.GET, url, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                    
                } else {
                    let data = JSON(jsonData!)
                    
                    let status = data["Status"].intValue
                    
                    if (status == 0) { //Error
                        self.errorMessage = data["ErrorMessage"].stringValue
                    } else if (status == 1) {//In Progress
                        self.errorCode = 1
                        self.errorMessage = "In Progress"
                    } else if (status == 2) {//Unsuccessful
                        self.errorMessage = "The command was sent but it took longer than expected"
                    } else if (status == 3) {//Successful
                        commandStatus = CommandStatus()
                        commandStatus!.longitude = data["Longitude"].doubleValue
                        commandStatus!.latitude = data["Latitude"].doubleValue
                        commandStatus!.location = data["Location"].stringValue
                        commandStatus!.speed = data["Speed"].doubleValue
                        commandStatus!.description = data["Description"].stringValue
                    }
                }
                completion(response: commandStatus)
        }
    } 
}