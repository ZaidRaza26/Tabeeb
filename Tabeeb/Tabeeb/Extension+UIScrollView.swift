//
//  Extension+UIScrollView.swift
//
//  Created by Invision on 08/03/2018.
//  Copyright © 2018 Invision. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}

extension UIScrollView{
    var currentPage:Int{
        return Int(round(contentOffset.x/frame.width))
    }
}
