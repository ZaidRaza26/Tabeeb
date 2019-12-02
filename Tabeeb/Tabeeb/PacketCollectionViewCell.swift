//
//  PacketCollectionViewCell.swift
//  Tabeeb
//
//  Created by Tamim Dari on 12/2/19.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit

class PacketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var dayOutlet: UILabel!
    @IBOutlet weak var statusOutlet: UILabel!
    
    var packet: Packet! {
           didSet{
            timeOutlet.text = packet.dateObject.toString(format: "HH:mm a")
            dayOutlet.text = packet.dateObject.toString(format: "EEEE")

//               lastMessageLabel.text = conversation.lastMessage
//               timeLabel.text = Date(timeIntervalSince1970: conversation.timestamp).timeAgo(numericDates: true)
           }
       }
       
    
    
    
    
}
