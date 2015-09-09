//
//  AppSettingService.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/7/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation
import CoreData

class AppSettingService: ServiceBase {
    let entityName = "AppSettingEntity"
    
    //Web API url
    func getWebServiceURL()->String {
        return self.getSetting(settingName: Settings.DATA_WEB_SERVICE_URL.rawValue, defaultValue: Settings.SERVICE_DEFAULT_URL.rawValue)
    }
    
    func setWebServiceURL(url: String) {
        self.saveSetting(settingName: Settings.DATA_WEB_SERVICE_URL.rawValue, settingValue: url)
    }
    
    //Map provider url
    func getMapURL()->String {
        return self.getSetting(settingName: Settings.DATA_MAP_URL.rawValue, defaultValue: Settings.MAP_OPENLAYERS_URL.rawValue)
    }
    
    func setMapURL(url: String) {
        self.saveSetting(settingName: Settings.DATA_MAP_URL.rawValue, settingValue: url)
    }
    
    //Login Data
    func getUserName()->String {
        return self.getSetting(settingName: Settings.DATA_USER_NAME.rawValue, defaultValue: "")
    }
    
    func setUserName(userName: String) {
        self.saveSetting(settingName: Settings.DATA_USER_NAME.rawValue, settingValue: userName)
    }
    
    func getPassword()->String {
        return self.getSetting(settingName: Settings.DATA_PASSWORD.rawValue, defaultValue: "")
    }
    
    func setPassword(password: String) {
        self.saveSetting(settingName: Settings.DATA_PASSWORD.rawValue, settingValue: password)
    }
    
    func getDeviceMode()->String {
        return self.getSetting(settingName: Settings.DATA_DEVICE_MODE.rawValue, defaultValue: Settings.MULTIPLE_DEVICE_MODE.rawValue)
    }
    
    func setDeviceMode(value: String) {
        self.saveSetting(settingName: Settings.DATA_DEVICE_MODE.rawValue, settingValue: value)
    }
    
   
    /* ------------------------------- Private Methods -------------------------------- */
    
    private func getSetting(#settingName: String, defaultValue: String) -> String {
        var value = defaultValue
        let request = NSFetchRequest(entityName: entityName)
        let predicate = NSPredicate(format: "settingName = %@", settingName)
        request.predicate = predicate
        
        if let results = global.dbContext!.executeFetchRequest(request, error: nil) as? [AppSettingEntity] {
            if !results.isEmpty {
                value = results[0].settingValue
            } else { //add a new record
                insertSetting(settingName: settingName, settingValue: defaultValue)
            }
        }
        return value
    }
    
    private func insertSetting(#settingName: String, settingValue: String) {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext: global.dbContext!) as AppSettingEntity
        newItem.settingName = settingName
        newItem.settingValue = settingValue
        
        global.dbContext!.save(nil)
    }
    
    private func saveSetting(#settingName: String, settingValue: String) {
        var request = NSFetchRequest(entityName: entityName)
        let predicate = NSPredicate(format: "settingName = %@", settingName)
        request.predicate = predicate
        
        if var results = global.dbContext!.executeFetchRequest(request, error: nil) as? [AppSettingEntity] {
            if results.count > 0 {
                results[0].settingValue = settingValue
                global.dbContext!.save(nil)
            }
        }
    }
}