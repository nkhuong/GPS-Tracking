//
//  ServiceBase.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/6/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation

class ServiceBase {
    var errorCode = 0
    var errorMessage = ""
    //var baseURL = "http://ws.skypatrol.com"
    func getServiceURL(url: ServiceURL) -> String {
        return global.baseURL + url.rawValue
    }
}

public enum ServiceURL:String {
    case Login = "/login"
    case InstallationRequest = "/installation_request"
	case ExchangeRequestTokenToAuthToken = "/exchange_auth_token"
    case CompleteInstallationRequest = "/complete_installation_request"
	case CreateUser = "/create_user_info"
    case CreateInstallationRequest = "/create_installation_request"
    case DeleteInstallationRequest = "/delete_installation_request"
    case UserInfo = "/user_info"
    case Report = "/installed_device"
    /*case UpdateUserInfo = "/user_info"
    case CreateUserInfo = "/create_user_info"*/
    case DecodeVIN = "/decode_vin"
    /* Command End Points */
    case Locate = "/v1/locate"
    case EnableStarter = "/v1/enable_starter"
    case DisableStarter = "/v1/disable_starter"
    case EnableLatePayment = "/v1/enable_late_payment"
    case DisableLatePayment = "/v1/disable_late_payment"
    case CommandStatus = "/v1/command_status"
}