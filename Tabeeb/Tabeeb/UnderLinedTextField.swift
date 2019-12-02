//
//  UnderLinedTextField.swift
//  Tabeeb
//
//  Created by macbook on 18/09/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit

@IBDesignable

class UnderLinedTextField: UITextField {
    @IBInspectable var lineHeight : CGFloat = 1.0

    @IBInspectable var lineColor : UIColor = UIColor.blue

    @IBInspectable var placeHolderColor : UIColor = UIColor.blue
    
    override func draw(_ rect: CGRect) {
        self.drawUnderLine(lineColor: lineColor, lineHeight: lineHeight)
        self.setAttributesToPlaceHolder(textColor: self.placeHolderColor)
    }
    
    private func setAttributesToPlaceHolder(textColor:UIColor){
        if(self.attributedPlaceholder?.string != nil){
            let placeholderString = NSMutableAttributedString(string:self.attributedPlaceholder!.string, attributes : [NSAttributedString.Key.foregroundColor:textColor])
            self.attributedPlaceholder = placeholderString
        }
    }
    
    private func drawUnderLine(lineColor:UIColor,lineHeight:CGFloat){
        let underline = CALayer()
        underline.borderColor = lineColor.cgColor
        underline.frame = CGRect(x: 0, y: self.frame.size.height - self.lineHeight, width: self.frame.size.width, height:self.lineHeight)
        underline.borderWidth = lineHeight
        self.layer.addSublayer(underline)
        self.layer.masksToBounds = true
    }
}
