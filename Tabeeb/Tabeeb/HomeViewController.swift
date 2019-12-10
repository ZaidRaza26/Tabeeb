//
//  HomeViewController.swift
//  Tabeeb
//
//  Created by macbook on 30/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    var packets:[Packet] = []

    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPackets()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.collectionView.bounds.height * 0.83, height: self.collectionView.bounds.height)

    }
    
    func getPackets(){
        
        Firestore.firestore().collection("packets").document(CurrentUser.shared.id).collection("packets").addSnapshotListener { (snapshot, error) in
                for change in snapshot?.documentChanges ?? []{
                        if change.type == DocumentChangeType.added{
                            let id = change.document.documentID
                            var dict = change.document.data()
                            dict["id"] = id
                            dict["date"] = (dict["date"] as! Timestamp).seconds
                            let packet:Packet = try! decode(with: dict)
                            self.packets.append(packet)
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                        
                    }

        
    }
    

}
}
extension HomeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packets.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PacketCollectionViewCell
        cell.packet = packets[indexPath.item]
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PacketCollectionViewCell
            else {return}
        cell.flip()
    }
}
