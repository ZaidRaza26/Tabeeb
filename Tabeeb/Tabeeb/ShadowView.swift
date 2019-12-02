//
//  ShadowView.swift
//  OddJobs
//
//  Created by Invision on 23/10/2018.
//  Copyright © 2018 Invision. All rights reserved.
//

import UIKit

@IBDesignable
final class ShadowView: UIView {
    
    override func draw(_ rect: CGRect) {
        setShadow(radius: 3.5, opacity: 0.1, cornerRadius: 10)
    }
    
    
    
    
}

extension UIView{
    func setShadow(of color:UIColor = .black, offset:CGSize = CGSize(width: 0, height: 0), radius: CGFloat = 1, opacity:Float = 0.5, cornerRadius:CGFloat = 10){
        guard let parent = superview else {return}
        parent.backgroundColor = .clear
        parent.layer.shadowColor = color.cgColor
        parent.layer.shadowOffset = offset
        parent.layer.shadowOpacity = opacity
        parent.layer.shadowRadius = radius
        parent.layer.shadowPath = UIBezierPath(roundedRect: parent.bounds, cornerRadius: cornerRadius).cgPath
        parent.layer.shouldRasterize = true
        parent.layer.rasterizationScale = UIScreen.main.scale
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}
