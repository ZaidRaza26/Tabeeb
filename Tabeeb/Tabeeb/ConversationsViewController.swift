//
//  ConversationsViewController.swift
//  Tabeeb
//
//  Created by macbook on 28/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit
import Firebase

class ConversationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var conversations : [Conversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getConversations()
    }
    
    @IBAction func consultTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ConsultViewController")
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func getConversations(){
        Firestore.firestore().collection("doctors-patients").document(CurrentUser.shared.id).addSnapshotListener { (snapshot, error) in
            
            for data in snapshot?.data() ?? [:]{
                if let conversationID = data.value as? String{
                    //let conversationID = dict[data.value] as! String
                    Firestore.firestore().collection("conversations").document(conversationID).getDocument(completion: { (snapshot, error) in
                        if let snapshot = snapshot, var dict = snapshot.data(){
                            dict["id"] = snapshot.documentID
                            let conversation:Conversation = try! decode(with: dict)
                            if let index = self.conversations.firstIndex(where: {$0.id == conversation.id}){
                                self.conversations[index] = conversation
                            }else{
                                self.conversations.insert(conversation, at: 0)
                            }
                            self.tableView.reloadData()
                        }
                    })
                }
            }
            
            
        }
    }
}


extension ConversationsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ConversationTableViewCell
        cell.conversation = conversations[indexPath.row]
        return cell
    }
}

extension ConversationsViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = self.conversations[indexPath.row]
        let chatVC = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatVC.conversation = conversation
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
