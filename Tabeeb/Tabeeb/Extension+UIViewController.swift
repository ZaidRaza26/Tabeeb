//
//  Extension+UIViewController.swift
//  Pillway
//
//  Created by Invision on 20/12/2018.
//  Copyright © 2018 Invision. All rights reserved.
//

import UIKit

extension UIViewController{
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
