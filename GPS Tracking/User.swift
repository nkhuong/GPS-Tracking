//
//  User.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/6/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation
class User {
    var userId:Int64 = 0
    var userName = ""
    var password = ""
    var firstName = ""
    var lastName = ""
    var address = ""
    var city = ""
    var state = ""
    var zip = ""
    var phone = ""
    var email = ""
    var loginToken = ""
    var fullName = ""
    
    func updateInfo(user: User) {
        if (user.userId > 0) {
            self.userId = user.userId
        }
        if (countElements(user.userName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.userName = user.userName
        }
        if (countElements(user.password.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.password = user.password
        }
        if (countElements(user.firstName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.firstName = user.firstName
        }
        if (countElements(user.lastName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.lastName = user.lastName
        }
        if (countElements(user.address.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.address = user.address
        }
        if (countElements(user.city.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.city = user.city
        }
        if (countElements(user.state.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.state = user.state
        }
        if (countElements(user.zip.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.zip = user.zip
        }
        if (countElements(user.phone.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.phone = user.phone
        }
        if (countElements(user.email.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.email = user.email
        }
        if (countElements(user.loginToken.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.loginToken = user.loginToken
        }
        if (countElements(user.fullName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) > 0) {
            self.fullName = user.fullName
        }
    }
}