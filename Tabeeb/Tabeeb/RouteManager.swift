//
//  AppManager.swift
//
//  Created by Invision on 08/05/2018.
//  Copyright © 2018 Invision. All rights reserved.
//

import UIKit

class RouteManager: NSObject {
    
    static var shared = RouteManager()
    
    private override init() {}
    
    var delegate:AppDelegate?{
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var window:UIWindow?? {
        return UIApplication.shared.delegate?.window
    }
   
    func show(_ viewController:UIViewController){
        clear(window: window)
        window??.rootViewController = viewController
    }

    func clear(window: UIWindow??) {
        window??.subviews.forEach { $0.removeFromSuperview() }
    }
    
}
