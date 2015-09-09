//
//  SavedDeviceEntity.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/19/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation
import CoreData

class SavedDeviceEntity: NSManagedObject {

    @NSManaged var serialNumber: String
    @NSManaged var deviceId: NSNumber
    @NSManaged var deviceName: String
    @NSManaged var subFleetId: NSNumber
    @NSManaged var subFleetName: String
    @NSManaged var companyId: NSNumber
    @NSManaged var companyName: String
    @NSManaged var imei: String
    @NSManaged var vin: String
    @NSManaged var make: String
    @NSManaged var model: String
    @NSManaged var year: String
    @NSManaged var color: String
    @NSManaged var avatar: String
    @NSManaged var authToken: String
    @NSManaged var stockNumber: String
    @NSManaged var licensePlate: String
    @NSManaged var marketPrice: Double
    @NSManaged var location: String
    @NSManaged var comment: String
    @NSManaged var starterInterruptInstalled: NSNumber

}
