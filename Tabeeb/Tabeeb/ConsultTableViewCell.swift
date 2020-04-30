//
//  ConsultTableViewCell.swift
//  Tabeeb
//
//  Created by macbook on 28/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit
import Firebase

protocol ConsultCellDelegate : class{
    func consulted(doctor:Doctor)
}

class ConsultTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specializationLabel: UILabel!
    
    weak var delegate:ConsultCellDelegate?
    
    var doctor : Doctor! {
        didSet{
            nameLabel.text = doctor.name
            specializationLabel.text = doctor.specialization
        }
    }
    
    
    @IBAction func consultTapped(_ sender: Any) {
        let ref = Firestore.firestore().collection("conversations").addDocument(data: ["lastMessage": "Send your first message",
                                                                                       "timestamp": Date().timeIntervalSince1970,
                                                                                       "doctorID": doctor.id,
                                                                                       "doctorName": doctor.name,
                                                                                       "patientName":CurrentUser.shared.name])
        Firestore.firestore().collection("doctors-patients").document(CurrentUser.shared.id).setData([doctor.id: ref.documentID], merge: true)
        Firestore.firestore().collection("doctors-patients").document(doctor.id).setData([CurrentUser.shared.id: ref.documentID], merge: true)
        Alert.show(message: "\(doctor.name) is added to your list of consultants") {
            self.delegate?.consulted(doctor: self.doctor)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
