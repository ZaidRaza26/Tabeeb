//
//  ConversationTableViewCell.swift
//  Tabeeb
//
//  Created by macbook on 29/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    var conversation : Conversation! {
        didSet{
            nameLabel.text = conversation.doctorName
            lastMessageLabel.text = conversation.lastMessage
            timeLabel.text = Date(timeIntervalSince1970: conversation.timestamp).timeAgo(numericDates: true)
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
