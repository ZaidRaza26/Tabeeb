//
//  Alert.swift
//  Tabeeb
//
//  Created by macbook on 20/09/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit

class Alert{
    //Show Alert with just a particular message
    class func show(on viewController:UIViewController = UIApplication.topViewController(), message:String, completion:(()->Void)? = nil){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            completion?()
        }
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    class func show(on viewController:UIViewController = UIApplication.topViewController(), title:String? = nil, message:String? = nil, type:UIAlertController.Style = .alert, action1:(title: String,completion: ()->Void)? = nil, action2: (title: String,completion: ()->Void)? = nil){
        let alertController=UIAlertController(title: title, message: message, preferredStyle: type)
        if let action1 = action1{
            let action=UIAlertAction(title: action1.title, style: UIAlertAction.Style.default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
                action1.completion()
            }
            alertController.addAction(action)
        }
        if let action2 = action2{
            let action=UIAlertAction(title: action2.title, style: UIAlertAction.Style.default) { (action) in
                alertController.dismiss(animated: true, completion: nil)
                action2.completion()
            }
            alertController.addAction(action)
        }
        let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
