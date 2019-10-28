//
//  Message.swift
//  Tabeeb
//
//  Created by macbook on 29/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import Foundation
import MessageKit

struct Message{
    let id:String
    let text:String
    let senderID:String
    let timestamp:Double
}

extension Message: MessageType{
    var sender: SenderType {
        if senderID == CurrentUser.shared.id{
            return CurrentUser.shared
        }
        return Doctor(id: senderID, name: "Doctor")
    }
    
    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    var kind: MessageKind {
        return MessageKind.text(text)
    }
}

extension Message: Codable{}
