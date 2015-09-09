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
        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive, error: nil)
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, countElements(self))) != nil
    }
}