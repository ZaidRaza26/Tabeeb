//
//  HomeViewController.swift
//  Tabeeb
//
//  Created by macbook on 30/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit
import Firebase
import UICircularProgressRing


class HomeViewController: UIViewController {
    var packets:[Packet] = []
    var arrayOfPacketsToCalculate:[Packet] = []
    
    
    
    
    @IBOutlet weak var circularRingOutlet: UICircularProgressRing!
    @IBOutlet weak var takenScore: UILabel!
    @IBOutlet weak var skippedScore: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPackets()
        getScore()
        collectionView.delegate = self
        collectionView.dataSource = self
        circularRingOutlet.style = .ontop
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: self.collectionView.bounds.height * 0.83, height: self.collectionView.bounds.height)
        
    }
    
    func getScore(){
    Firestore.firestore().collection("packets").document(CurrentUser.shared.id).collection("packets").addSnapshotListener { (snapshot, error) in
        
        for change in snapshot?.documentChanges ?? []{
            let id = change.document.documentID
            var dict = change.document.data()
            dict["id"] = id
            dict["date"] = (dict["date"] as! Timestamp).seconds
            let packet:Packet = try! decode(with: dict)
            if change.type == DocumentChangeType.added{
                self.arrayOfPacketsToCalculate.append(packet)
            }
            else if change.type == DocumentChangeType.modified{
                if let index = self.arrayOfPacketsToCalculate.lastIndex(where: {$0.id == packet.id}){
                    self.arrayOfPacketsToCalculate[index] = packet
                }
            }
        }
        
        
        
        
        var taken = 0
        var remaining = 0
        var totalPercent:Double = 0.0
        for item in self.arrayOfPacketsToCalculate{
            if item.action == 2{
                taken += 1
            }
        }
        remaining = self.arrayOfPacketsToCalculate.count - taken
        self.takenScore.text = "\(taken)"
        self.skippedScore.text = "\(remaining)"
        totalPercent = Double(taken) / Double(self.arrayOfPacketsToCalculate.count)
        totalPercent = totalPercent * 100
        self.circularRingOutlet.value = CGFloat(totalPercent)
    }
           
}
    
    
    
    
    
    
    func getPackets(){
        
        Firestore.firestore().collection("packets").document(CurrentUser.shared.id).collection("packets").addSnapshotListener { (snapshot, error) in
            
            for change in snapshot?.documentChanges ?? []{
                let id = change.document.documentID
                var dict = change.document.data()
                dict["id"] = id
                dict["date"] = (dict["date"] as! Timestamp).seconds
                let packet:Packet = try! decode(with: dict)
                if change.type == DocumentChangeType.added{
                    
                    
                    if(Calendar.current.isDateInToday(packet.dateObject)){
                        self.packets.append(packet)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }else if change.type == DocumentChangeType.modified{
                    if let index = self.packets.lastIndex(where: {$0.id == packet.id}){
                        self.packets[index] = packet
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





       
