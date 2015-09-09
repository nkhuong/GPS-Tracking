//
//  InstallationRequestService.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/7/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation
class InstallationRequestService : ServiceBase {
    
    func getInstallationrequests(loginToken: String, completion: (response:[InstallationInfo]) -> ()){
        var installationList: [InstallationInfo] = []
        let url = getServiceURL(ServiceURL.InstallationRequest) + "/" + loginToken
        Alamofire.manager.request(.GET, url, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                    
                } else {
                    let data = JSON(jsonData!)
                    
                    for (key: String, aRequest: JSON) in data["RequestsList"] {
                        var installationRequest = InstallationInfo()
                        installationRequest.deviceId = aRequest["TObjectId"].int64Value
                        installationRequest.deviceName = aRequest["DeviceName"].stringValue
                        installationRequest.subFleetId = aRequest["SubFleetId"].int64Value
                        installationRequest.subFleetName = aRequest["SubFleetName"].stringValue
                        installationRequest.companyId = aRequest["CompanyId"].int64Value
                        installationRequest.companyName = aRequest["CompanyName"].stringValue
                        installationRequest.serialNumber = aRequest["SerialNumber"].stringValue
                        installationRequest.imei = aRequest["IMEI"].stringValue
                        installationRequest.vin = aRequest["VIN"].stringValue
                        installationRequest.make = aRequest["Make"].stringValue
                        installationRequest.model = aRequest["Model"].stringValue
                        installationRequest.year = aRequest["Year"].stringValue
                        installationRequest.color = aRequest["Color"].stringValue
                        installationRequest.avatar = aRequest["Avatar"].stringValue
                        installationRequest.authToken = aRequest["Token"].stringValue
                        
                        installationList.append(installationRequest)
                    }
                }
                completion(response: installationList)
        }
    }
    
    func createInstallationRequest (#userId: Int64, serial: String, reInstalled: Bool, completion: (response: InstallationInfo?)->()) {
        var info: InstallationInfo? = nil
        
        let url = getServiceURL(ServiceURL.CreateInstallationRequest)
        let parameters : [String : AnyObject] = [
            "userId": Int(userId),
            "serialNumber": serial,
            "reInstalled": reInstalled
        ]
        
        Alamofire.manager.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                    
                } else {
                    let data = JSON(jsonData!)
                    let rootTag = "create_installation_requestResult"
                    
                    if data[rootTag][JSONTags.SUCCESS.rawValue].intValue == 0 || data[rootTag]["InstallToken"].stringValue == "" {
                        self.errorCode = data[rootTag][JSONTags.ERROR_CODE.rawValue].intValue
                        self.errorMessage = data[rootTag][JSONTags.ERROR_MESSAGE.rawValue].stringValue
                    }
                    else {
                        info = InstallationInfo()
                        info!.serialNumber = serial
                        info!.authToken = data[rootTag]["InstallToken"].stringValue
                        info!.deviceId = data[rootTag]["DeviceId"].int64Value
                        info!.avatar = data[rootTag]["Avatar"].stringValue
                        info!.companyName = data[rootTag]["CompanyName"].stringValue
                        info!.deviceName = data[rootTag]["Name"].stringValue
                        
                        //update global variable
                        if global.user.userId == 0 {
                            global.user.userId = userId
                        } else if global.user.userId == -1 {
                            global.user.loginToken = data[rootTag]["AuthToken"].stringValue
                        }
                    }
                }
                completion(response: info)
        }
    }
    
    func completeInstallationRequest (#info: InstallationInfo, user: User, completion: (response: Bool) -> ()) {
        var successResult = false
        let url = getServiceURL(ServiceURL.CompleteInstallationRequest)
        
        var installerName = user.fullName
        if countElements(installerName) == 0 {
            installerName = user.firstName + " " + user.lastName
        }
        
        var parameters: [String : AnyObject] = [
            "token": info.authToken,
            "authtoken": user.loginToken,
            "serial": info.serialNumber,
            "installer": installerName,
            "vin": info.vin,
            "make": info.make,
            "year": info.year,
            "model": info.model,
            "color": info.color,
            "deviceName": info.deviceName,
            "stockNumber": info.stockNumber,
            "licensePlate": info.licensePlate,
            "marketPrice": info.marketPrice,
            "starterInterruptInstalled": info.starterInterruptInstalled,
            "location": info.location,
            "comment": info.comment
        ]
//        if !info.deviceName.isEmpty {
//            parameters["deviceName"] = info.deviceName
//        }
        
        
        Alamofire.manager.request(.POST, url, parameters: parameters, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                    
                } else {
                    let data = JSON(jsonData!)
                    let rootTag = "complete_installation_requestResult"
                    let errorMes: String = data[rootTag][JSONTags.ERROR_MESSAGE.rawValue].stringValue
                    if  countElements(errorMes) == 0 || errorMes.uppercaseString == "NULL" {
                        successResult = true
                    }
                    else {
                        self.errorCode = 404
                        self.errorMessage = "Service Connection failed! Please try again."
                    }
                }
                completion(response: successResult)
        }
    }
    
    func deleteInstallationRequest (#token: String, installToken: String, completion: (response: Bool)->()) {
        var successResult = false
        let url = getServiceURL(ServiceURL.DeleteInstallationRequest) + "/" + token + "/" + installToken
        Alamofire.manager.request(.GET, url, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error == nil {
                    let data = JSON(jsonData!)
                    
                    self.errorCode = data[JSONTags.ERROR_CODE.rawValue].intValue
                    if self.errorCode == 0 {
                        successResult = true
                    } else {
                        self.errorMessage = data[JSONTags.ERROR_MESSAGE.rawValue].stringValue
                    }
                } else {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                }
                completion(response: successResult)
        }
    }
    
    /*
    {
    ErrorCode: null
    ErrorMessage: null
    TransactionId: 0
    InstallDevices: [3]
    0:  {
				Install_Date: "/Date(1414696599000-0400)/"
				Installer_Name: ""
				Serial_Number: "SF112158007237"
				Stock_Number: ""
    }
    1:  {
				Install_Date: "/Date(1418687617837-0500)/"
				Installer_Name: ""
				Serial_Number: "6361542590252"
				Stock_Number: ""
    }
    2:  {
				Install_Date: "/Date(1419224400000-0500)/"
				Installer_Name: ""
				Serial_Number: "6361542590253"
				Stock_Number: ""
    }
    Total: 3
    }
    */
    func report(#token: String, startDate: String, endDate: String, pageIndex: Int, pageCount: Int, completion: (response:[InstalledDevice]) -> ()) {
        var installedDeviceList: [InstalledDevice] = []
        let url = getServiceURL(ServiceURL.Report) + "/\(token)/\(startDate)/\(endDate)/\(pageIndex)/\(pageCount)"
        Alamofire.manager.request(.GET, url, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 404
                    self.errorMessage = "Service Connection failed! Please try again."
                    
                } else {
                    let data = JSON(jsonData!)
                    
                    if data != nil {
                        for (key: String, aDevice: JSON) in data["InstallDevices"] {
                            var device = InstalledDevice()
                            device.installDate = NSDate(jsonDate: aDevice["Install_Date"].stringValue)
                            device.installerName = aDevice["Installer_Name"].stringValue
                            device.serialNumber = aDevice["Serial_Number"].stringValue
                            device.stockNumber = aDevice["Stock_Number"].stringValue
                            installedDeviceList.append(device)
                        }
                    } else {
                        self.errorCode = 404
                        self.errorMessage = "Service Connection failed! Please try again."
                    }
                }
                completion(response: installedDeviceList)
        }
    }
}
