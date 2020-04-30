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
    let type:Int
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
       // let dateConverted = Float(timestamp)
       // return Date(timeIntervalSince1970: TimeInterval(dateConverted))
        return Date(timeIntervalSince1970: timestamp)
    }
    
    var kind: MessageKind {
        if type == 1{
            return .photo(Photo(base64: text))
        }
        return .text(text)
    }
}

extension Message: Codable{}

class Photo:MediaItem{
    var url: URL? = nil
    
    var image: UIImage?
    
    var placeholderImage: UIImage = UIImage()
    
    var size: CGSize = CGSize(width: 200, height: 200)
    
    init(base64:String) {
        image = UIImage(data: Data(base64Encoded: base64)!)
    }
}
