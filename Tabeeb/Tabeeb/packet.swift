//
//  packet.swift
//  Tabeeb
//
//  Created by Tamim Dari on 12/2/19.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import Foundation
struct Packet: Codable {
    let id:String
    let date:TimeInterval
    let drugs:String
    let dosage:String
    let notes:String
    
    var dateObject:Date{
        return Date(timeIntervalSince1970: date)
    }
}
