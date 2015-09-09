//
//  DateUtil.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/31/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation

extension NSDate {
    convenience init?(jsonDate: String) {
        let prefix = "/Date("
        let suffix = ")/"
        // Check for correct format:
        if jsonDate.hasPrefix(prefix) && jsonDate.hasSuffix(suffix) {
            // Extract the number as a string:
            let from = jsonDate.startIndex.advancedBy(countElements(prefix))
            let to = jsonDate.endIndex.advancedBy(-countElements(suffix))
            let dateGMTString = jsonDate[from ..< to]
            
            var dateString:String = "", gmt: String = ""
            if dateGMTString.rangeOfString("-") != nil {
                let arr = dateGMTString.componentsSeparatedByString("-")
                dateString = arr[0]
                gmt = " -" + arr[1]
            } else {
                let arr = dateGMTString.componentsSeparatedByString("+")
                dateString = arr[0]
                gmt = " +" + arr[1]
            }
            
            // Convert to double and from milliseconds to seconds:
            let timeStamp = (dateString as NSString).doubleValue / 1000.0
            
            // Create NSDate with this UNIX timestamp
            let tmpDate = NSDate(timeIntervalSince1970: timeStamp)
            
            //Convert NSDate to String
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(name: "GMT")
            let strDate = dateFormatter.stringFromDate(tmpDate) + gmt
            
            dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
            
            let date = dateFormatter.dateFromString(strDate)
            self.init(timeInterval:0, sinceDate:date!)
        } else {
            // Wrong format, return nil. (The compiler requires us to
            // to an initialization first.)
            self.init(timeIntervalSince1970: 0)
            return nil
        }
    }
    
    func toString(dateFormat: String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat //"MM/dd/yyyy HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "GMT")
        return formatter.stringFromDate(self)
    }
    
    func getDay()->Int? {
        let components = NSCalendar.currentCalendar().components(.NSDayCalendarUnit, fromDate: self)
        return components.day + 1
    }
    
    func getMonth()->Int? {
        let components = NSCalendar.currentCalendar().components(.NSMonthCalendarUnit, fromDate: self)
        return components.month
    }
    
    func getYear()->Int? {
        let components = NSCalendar.currentCalendar().components(.NSYearCalendarUnit, fromDate: self)
        return components.year
    }
    
    func getHour()->Int? {
        let components = NSCalendar.currentCalendar().components(.NSHourCalendarUnit, fromDate: self)
        return components.hour
    }
    
    func getMinute()->Int? {
        let components = NSCalendar.currentCalendar().components(.NSMinuteCalendarUnit, fromDate: self)
        return components.minute
    }
    
    func getSecond()->Int? {
        let components = NSCalendar.currentCalendar().components(.NSSecondCalendarUnit, fromDate: self)
        return components.second
    }
    
    func addDays(additionalDays: Int) -> NSDate {
        // adding $additionalDays
        var components = NSDateComponents()
        components.day = additionalDays
        
        // important: NSCalendarOptions(0)
        let futureDate = NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: self, options: NSCalendarOptions(rawValue: 0))
        return futureDate!
    }
}
/*
if let theDate = NSDate(jsonDate: "/Date(1418687617837-0500)/") {
    println(theDate)
} else {
    println("wrong format")
}
*/