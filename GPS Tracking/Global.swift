//
//  Global.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/8/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation
import CoreData
var global: Global = Global()

class Global {
    var dbContext: NSManagedObjectContext? = nil
    var user: User = User()
    var installationInfo: InstallationInfo = InstallationInfo()
    var commandResults: [Int:(Int, Int)] = [Int:(Int, Int)]()
    var baseURL = ""
}