//
//  RingingViewController.swift
//  Tabeeb
//
//  Created by Tamim Dari on 2/24/20.
//  Copyright © 2020 SZABIST. All rights reserved.
//

import UIKit

class RingingViewController: UIViewController {

    var videocall: VideoCall!
    @IBOutlet var PickButtonOutlet: UIButton!
    @IBOutlet var CancelButtonOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

  
    @IBAction func PickTapped(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Video") as? VideoCallViewController{
            vc.videocall = self.videocall
            navigationController?.pushViewController(vc, animated: true)

        }
    }
    
    @IBAction func CancelTapped(_ sender: Any) {
            
        self.navigationController?.dismiss(animated: true, completion: nil)

               
    }
}
