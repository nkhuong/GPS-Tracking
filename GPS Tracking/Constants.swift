//
//  Constants.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/6/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation

//json tags
enum JSONTags : String {
    case SUCCESS = "Success"
    case ERROR_CODE = "ErrorCode"
    case ERROR_MESSAGE = "ErrorMessage"
    case TOKEN = "Token"
}

//barcode scan type
enum BarCodeScanType:Int {
    case ZBAR_SCANNER_REQUEST = 0, ZBAR_QR_SCANNER_REQUEST
}


//returning results
enum Results: Int{
    case COMMANDRESULT_INVALID_USERNAME_OR_PASSWORD = 2
    case COMMANDRESULT_INVALID_IMEI = 3
    case COMMANDRESULT_USER_NOTALLOW_COMMAND = 4
    case COMMANDRESULT_COMMAND_ID_NOT_FOUND = 5
    case PARAMETERS_REQUIRED = 6
    case DEVICE_INSTALLED = 7
}

//sending command
enum Commands: Int {
    case LOCATE = 0
    case ENABLE_STARTER = 1
    case DISABLE_STARTER = 2
    case ENABLE_LATE_PAYMENT = 3
    case DISABLE_LATE_PAYMENT = 4

}

let CommandNames: [String] = ["Locate", "Starter enable", "Starter disable", "Enable late payment", "Disable late payment"]

//Settings
enum Settings: String {
    case DATA_WEB_SERVICE_URL = "WebServiceURL"
    case DATA_MAP_URL = "MapURL"
    case DATA_USER_NAME = "UserName"
    case DATA_PASSWORD = "Password"
    case DATA_DEVICE_MODE = "DeviceMode"
    
    case SERVICE_DEFAULT_URL = "http://wsp.skypatrol.com"
    case FORGOT_PASSWORD_URL = "http://defenderqa.skypatrol.com/Home/ForgotPassword"
    case MAP_GOOGLE_URL = "map_googlev3"
    case MAP_OPENLAYERS_URL = "map_openlayers"
    
    case SINGLE_DEVICE_MODE = "SINGLE"
    case MULTIPLE_DEVICE_MODE = "MULTIPLE"
}

let NoInterNetConnection = "Please check your internet connection!"
