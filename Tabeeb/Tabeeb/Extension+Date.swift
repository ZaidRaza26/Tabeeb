//
//  Extension+Date.swift
//  Pillway
//
//  Created by Invision on 20/12/2018.
//  Copyright © 2018 Invision. All rights reserved.
//

import Foundation


extension Date{
    func toString(format:String, timezone:TimeZone = .current)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timezone
        //formatter.locale = Locale(identifier: Locale.current.identifier)
        return formatter.string(from: self)
    }
}
