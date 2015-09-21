//
//  SavedDeviceService.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/7/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation
import CoreData

class SavedDeviceService {
    let entityName = "SavedDeviceEntity"
    
    func get(serial: String, completion: (response: InstallationInfo?)->()) {
        var info: InstallationInfo? = nil
        
        let request = NSFetchRequest(entityName: entityName)
        let predicate = NSPredicate(format: "serialNumber = %@", serial)
        request.predicate = predicate
        
<<<<<<< HEAD
        if let results = (try? global.dbContext!.executeFetchRequest(request)) as? [SavedDeviceEntity] {
=======
        if let results = global.dbContext!.executeFetchRequest(request, error: nil) as? [SavedDeviceEntity] {
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
            if !results.isEmpty {
                info = self.newInfoFromEntity(results[0])
            }
        }
        completion(response: info)
    }
    
    func getAll(completion: (response: [InstallationInfo])->()) {
        var list: [InstallationInfo] = []
        
        let request = NSFetchRequest(entityName: entityName)
        
<<<<<<< HEAD
        if let results = (try? global.dbContext!.executeFetchRequest(request)) as? [SavedDeviceEntity] {
=======
        if let results = global.dbContext!.executeFetchRequest(request, error: nil) as? [SavedDeviceEntity] {
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
            if results.count > 0 {
                for device in results {
                    list.append(newInfoFromEntity(device))
                }
            }
        }
        completion(response: list)
    }
    
    func save(info: InstallationInfo, completion: (response: Bool)->()) {
        self.get(info.serialNumber) {result in
            if result == nil {
                self.add(info) {result in
                    completion(response: result)
                }
            } else {
                self.update(info) {result in
                    completion(response: result)
                }
            }
        }
    }
    
    func remove(serialNumber: String, completion: (response: Bool)->()) {
        var success = false
        
<<<<<<< HEAD
        let request = NSFetchRequest(entityName: entityName)
        let predicate = NSPredicate(format: "serialNumber = %@", serialNumber)
        request.predicate = predicate
        
        if let results = (try? global.dbContext!.executeFetchRequest(request)) as? [SavedDeviceEntity] {
=======
        var request = NSFetchRequest(entityName: entityName)
        let predicate = NSPredicate(format: "serialNumber = %@", serialNumber)
        request.predicate = predicate
        
        if var results = global.dbContext!.executeFetchRequest(request, error: nil) as? [SavedDeviceEntity] {
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
            for device in results {
                global.dbContext!.deleteObject(device)
                success = true
            }
        }
        
        completion(response: success)
    }
    
    private func add(info: InstallationInfo, completion: (response: Bool)->()) {
<<<<<<< HEAD
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: global.dbContext!) as! SavedDeviceEntity
=======
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: global.dbContext!) as SavedDeviceEntity
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
        
        newItem.serialNumber = info.serialNumber
        newItem.deviceId = NSNumber(longLong: info.deviceId)
        newItem.deviceName = info.deviceName
        newItem.subFleetId = NSNumber(longLong: info.subFleetId)
        newItem.subFleetName = info.subFleetName
        newItem.companyId = NSNumber(longLong: info.companyId)
        newItem.companyName = info.companyName
        newItem.imei = info.imei
        newItem.vin = info.vin
        newItem.make = info.make
        newItem.model = info.model
        newItem.year = info.year
        newItem.color = info.color
        newItem.avatar = info.avatar
        newItem.authToken = info.authToken
        newItem.stockNumber = info.stockNumber
        newItem.licensePlate = info.licensePlate
        newItem.marketPrice = info.marketPrice
        newItem.location = info.location
        newItem.comment = info.comment
        newItem.starterInterruptInstalled = info.starterInterruptInstalled.boolValue
        
<<<<<<< HEAD
        do {
            try global.dbContext!.save()
        } catch _ {
        }
    }
    private func update(info: InstallationInfo, completion: (reponse: Bool)->()) {
        let request = NSFetchRequest(entityName: entityName)
        let predicate = NSPredicate(format: "serialNumber = %@", info.serialNumber)
        request.predicate = predicate
        
        if var results = (try? global.dbContext!.executeFetchRequest(request)) as? [SavedDeviceEntity] {
=======
        global.dbContext!.save(nil)
    }
    private func update(info: InstallationInfo, completion: (reponse: Bool)->()) {
        var request = NSFetchRequest(entityName: entityName)
        let predicate = NSPredicate(format: "serialNumber = %@", info.serialNumber)
        request.predicate = predicate
        
        if var results = global.dbContext!.executeFetchRequest(request, error: nil) as? [SavedDeviceEntity] {
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
            if results.count > 0 {
                results[0].serialNumber = info.serialNumber
                results[0].deviceId = NSNumber(longLong: info.deviceId)
                results[0].deviceName = info.deviceName
                results[0].subFleetId = NSNumber(longLong: info.subFleetId)
                results[0].subFleetName = info.subFleetName
                results[0].companyId = NSNumber(longLong: info.companyId)
                results[0].companyName = info.companyName
                results[0].imei = info.imei
                results[0].vin = info.vin
                results[0].make = info.make
                results[0].model = info.model
                results[0].year = info.year
                results[0].color = info.color
                results[0].avatar = info.avatar
                results[0].authToken = info.authToken
                results[0].stockNumber = info.stockNumber
                results[0].licensePlate = info.licensePlate
                results[0].marketPrice = info.marketPrice
                results[0].location = info.location
                results[0].comment = info.comment
                results[0].starterInterruptInstalled = info.starterInterruptInstalled.boolValue
<<<<<<< HEAD
                do {
                    try global.dbContext!.save()
                } catch _ {
                }
=======
                global.dbContext!.save(nil)
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
            }
        }
    }
    
    private func newInfoFromEntity(entity: SavedDeviceEntity) -> InstallationInfo {
<<<<<<< HEAD
        let info = InstallationInfo()
=======
        var info = InstallationInfo()
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
        
        info.serialNumber = entity.serialNumber
        info.deviceId = entity.deviceId.longLongValue
        info.deviceName = entity.deviceName
        info.subFleetId = entity.subFleetId.longLongValue
        info.subFleetName = entity.subFleetName
        info.companyId = entity.companyId.longLongValue
        info.companyName = entity.companyName
        info.imei = entity.imei
        info.vin = entity.vin
        info.make = entity.make
        info.model = entity.model
        info.year = entity.year
        info.color = entity.color
        info.avatar = entity.avatar
        info.authToken = entity.authToken
        info.stockNumber = entity.stockNumber
        info.marketPrice = entity.marketPrice
        info.licensePlate = entity.licensePlate
        info.location = entity.location
        info.comment = entity.comment
        info.starterInterruptInstalled = entity.starterInterruptInstalled.boolValue
        
        return info
    }
}