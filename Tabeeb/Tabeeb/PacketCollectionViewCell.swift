//
//  PacketCollectionViewCell.swift
//  Tabeeb
//
//  Created by Tamim Dari on 12/2/19.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit
import Firebase

class PacketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var drugOutlet: UILabel!
    @IBOutlet weak var timeOutlet: UILabel!
    @IBOutlet weak var dayOutlet: UILabel!
    @IBOutlet weak var statusOutlet: UILabel!
    
    var packet: Packet! {
           didSet{
            timeOutlet.text = packet.dateObject.toString(format: "HH:mm a")
            dayOutlet.text = packet.dateObject.toString(format: "EEEE")
            drugOutlet.text = packet.drugs + packet.dosage

//               lastMessageLabel.text = conversation.lastMessage
//               timeLabel.text = Date(timeIntervalSince1970: conversation.timestamp).timeAgo(numericDates: true)
           }
       }
       
    
    
   
    @IBAction func skipTapped(_ sender: UIButton) {
        // Update one field, creating the document if it does not exist.
        Firestore.firestore().collection("packets").document(CurrentUser.shared.id).collection("packets").document(packet.id).setData([ "action": "1" ], merge: true)
    }
    
    
    @IBAction func takenTapped(_ sender: Any) {
        Firestore.firestore().collection("packets").document(CurrentUser.shared.id).collection("packets").document(packet.id).setData([ "action": "2" ], merge: true)
    }
    
    
    
}
