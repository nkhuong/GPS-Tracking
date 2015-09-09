//
//  InstallationInfo.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/7/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation
class InstallationInfo {
    var deviceId: Int64 = 0 //TObjectId
    var deviceName = ""
    var subFleetId:Int64 = 0;
    var subFleetName = ""
    var companyId:Int64 = 0
    var companyName = ""
    var serialNumber = ""
    var imei = ""
    var vin = ""
    var make = ""
    var model = ""
    var year = ""
    var color = ""
    var avatar = ""
    var authToken = ""
    
    var stockNumber = ""
    var licensePlate = "" //PlateNo
    var marketPrice = 0.0
    var starterInterruptInstalled = false
    var location = "" //InstallLocation
    var comment = ""
    
    func updateInfo(info: InstallationInfo) {
        if (info.deviceId > 0) {
            self.deviceId = info.deviceId
        }
        if (countElements(info.deviceName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.deviceName = info.deviceName
        }
        if (info.subFleetId > 0) {
            self.subFleetId = info.subFleetId
        }
        if (countElements(info.subFleetName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.subFleetName = info.subFleetName
        }
        if (info.companyId > 0) {
            self.companyId = info.companyId
        }
        if (countElements(info.companyName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.companyName = info.companyName
        }
        if (countElements(info.serialNumber.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.serialNumber = info.serialNumber
        }
        if (countElements(info.imei.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.imei = info.imei
        }
        if (countElements(info.vin.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.vin = info.vin
        }
        if (countElements(info.make.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.make = info.make
        }
        if (countElements(info.model.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.model = info.model
        }
        if (countElements(info.year.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.year = info.year
        }
        if (countElements(info.color.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.color = info.color
        }
        if (countElements(info.avatar.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.avatar = info.avatar
        }
        if (countElements(info.authToken.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.authToken = info.authToken
        }
        
        if (countElements(info.stockNumber.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.stockNumber = info.stockNumber
        }
        if (countElements(info.licensePlate.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.licensePlate = info.licensePlate
        }
        if (info.starterInterruptInstalled) {
            self.starterInterruptInstalled = info.starterInterruptInstalled
        }
        if (countElements(info.location.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.location = info.location
        }
        if (countElements(info.comment.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.comment = info.comment
        }
        if (info.marketPrice > 0.0) {
            self.marketPrice = info.marketPrice
        }
    }
}