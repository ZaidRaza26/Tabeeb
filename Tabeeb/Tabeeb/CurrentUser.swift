//
//  CurrentUser.swift
//  Tabeeb
//
//  Created by macbook on 27/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import Foundation

class CurrentUser:Codable{
    let id:String
    let name:String
    let email:String
    let dob:String
    
    static var shared:CurrentUser!
}
