//
//  StringUtil.swift
//  Install
//
//  Created by Tran Thanh Dan on 1/10/15.
//  Copyright (c) 2015 Skypatrol LLC. All rights reserved.
//

import Foundation

extension String {
    func isEmail() -> Bool {
<<<<<<< HEAD
        let regex = try? NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive)
        return regex?.firstMatchInString(self, options: [], range: NSMakeRange(0, countElements(self))) != nil
=======
        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive, error: nil)
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, countElements(self))) != nil
>>>>>>> 245be3e6ff50b0b50f2d3a4edd00fc4f434d1ebf
    }
}