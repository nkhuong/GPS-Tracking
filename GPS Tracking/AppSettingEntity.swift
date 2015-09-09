//
//  AppSettingEntity.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/18/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation
import CoreData

class AppSettingEntity: NSManagedObject {

    @NSManaged var settingName: String
    @NSManaged var settingValue: String

}
