//
//  VinService.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/7/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation


class VinService : ServiceBase {
    //decode VIN
    func decodeVIN(vin: String, completion: (response: InstallationInfo?) -> ()) {
        var info: InstallationInfo? = nil
        let url = getServiceURL(ServiceURL.DecodeVIN) + "/" + vin
        
        Alamofire.manager.request(.GET, url, encoding: .JSON)
            .responseJSON {(request, response, jsonData, error) in
                if error != nil {
                    self.errorCode = 400
                    self.errorMessage = "Can not decode VIN!"
                } else {
                    
                    let data = JSON(jsonData!)
                    //convert string to NSData
                    let jsonString = (data["JsonData"].stringValue as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
                    //create json Object from string
                    let jsonObject : AnyObject! = NSJSONSerialization.JSONObjectWithData(jsonString, options: NSJSONReadingOptions.MutableContainers, error: nil)
                    //init SwiftyJson
                    let jsonData = JSON(jsonObject)
                    
                    if (jsonData != nil) {
                        info = InstallationInfo()
                        info!.vin   = vin
                        info!.make  = jsonData["make"]["name"].stringValue
                        info!.model = jsonData["model"]["name"].stringValue
                        info!.year  = jsonData["years"][0]["year"].stringValue
                        info!.color = jsonData["colors"][0]["options"][0]["name"].stringValue                        
                    }
                    else {
                        self.errorCode = 400
                        self.errorMessage = "Can not decode VIN!"
                    }
                }
                completion(response: info)
        }
    }
}
