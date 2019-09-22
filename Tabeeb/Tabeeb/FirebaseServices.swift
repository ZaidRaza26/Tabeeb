//
//  FirebaseServices.swift
//  Tabeeb
//
//  Created by macbook on 20/09/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import Foundation
import Firebase




class FirebaseServices{
    class func signUp(name:String,email:String,password:String,dob:String,completion:@escaping (Result<Bool>) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error.localizedDescription))
            }
            else {
            }
        }
        
    }
}
