//
//  Alert.swift
//  Tabeeb
//
//  Created by macbook on 20/09/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import JGProgressHUD
import UIKit
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) ->
        UIViewController {
            if let navigationController = controller as? UINavigationController {
                return topViewController(controller: navigationController.visibleViewController)
            }
            if let tabController = controller as? UITabBarController {
                if let selected = tabController.selectedViewController {
                    return topViewController(controller: selected)
                }
            }
            if let presented = controller?.presentedViewController {
                return topViewController(controller: presented)
            }
            return controller!
    }
}


extension UIApplication{
    //Show hide loader.
    class func startActivityIndicator(with message: String? = "") {
        let hud = JGProgressHUD(style: .dark)
        hud.tag = 999
        hud.textLabel.text = message
        if let view = self.shared.keyWindow {
            hud.show(in: view)
        }
    }
    
    class func stopActivityIndicator(){
        if let hud = self.shared.keyWindow?.viewWithTag(999) as? JGProgressHUD {
            hud.dismiss()
            hud.removeFromSuperview()
        }
    }
}
