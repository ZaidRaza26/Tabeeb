//
//  Doctors.swift
//  Tabeeb
//
//  Created by macbook on 28/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import Foundation

struct Doctor{
    let id : String
    let name : String
    let specialization : String
}

extension Doctor{
    init(id:String, name:String) {
        self.id = id
        self.name = name
        self.specialization = ""
    }
}

extension Doctor: Codable{

}
