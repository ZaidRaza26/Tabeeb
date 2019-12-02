//
//  ConsultViewController.swift
//  Tabeeb
//
//  Created by macbook on 28/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit
import Firebase

class ConsultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var doctors : [Doctor] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        db.collection("doctors").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let doctor:Doctor = try! decode(with: document.data())
                    self.doctors.append(doctor)
                }
                self.tableView.reloadData()
            }
        }

    }
    
    



}

extension ConsultViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctors.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ConsultTableViewCell
        cell?.doctor = doctors[indexPath.row]
        return cell!
    }
}
