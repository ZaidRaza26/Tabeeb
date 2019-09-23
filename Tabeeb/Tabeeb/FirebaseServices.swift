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
            else if let result = authResult  {
                let userID = result.user.uid
                let ref = Database.database().reference().child("users").child(userID)
                ref.setValue(["email":email,
                              "name":name,
                              "dob":dob])
                completion(.success(true))
            }
        }
        
    }
    
    class func login(email:String,password:String,completion:@escaping (Result<Bool>) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(.failure(error.localizedDescription))
            }
            else if let result = authResult {
                let userID = result.user.uid
                let ref = Database.database().reference().child("users").child(userID)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    let dict = snapshot.value as! NSDictionary
                    if let name = dict.value(forKey: "name") as? String, let email = dict.value(forKey: "email") as? String,let dob = dict.value(forKey: "dob") as? String{
                        User.shared = User(name: name, email: email, dob: dob)
                        completion(.success(true))
                    }
                })
            }
        }
    }
}

class User{

    static var shared:User!
    
    let name:String
    let email:String
    let dob:String
    
    init(name:String, email:String, dob:String) {
        self.name = name
        self.email = email
        self.dob = dob
    }
}
