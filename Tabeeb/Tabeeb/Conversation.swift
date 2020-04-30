//
//  Conversation.swift
//  Tabeeb
//
//  Created by macbook on 28/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import Foundation

class Conversation: Codable{
    let id : String
    let lastMessage : String
    let timestamp : Double
    let doctorID : String
    let doctorName : String
    let patientName: String
    
}
