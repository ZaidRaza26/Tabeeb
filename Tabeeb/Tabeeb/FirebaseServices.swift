//
//  FirebaseServices.swift
//  Tabeeb
//
//  Created by macbook on 20/09/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import Foundation
import Firebase

var device_Token : String = ""
class FirebaseServices{
    class func signUp(name:String,email:String,password:String,dob:String,completion:@escaping (Result<Bool>) -> Void){
        
        let db = Firestore.firestore()
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error.localizedDescription))
            }
            else if let result = authResult  {
                let userID = result.user.uid
                let dict = ["id": userID,
                            "email":email,
                            "name":name,
                            "dob":dob,
                            "deviceToken":device_Token]
                db.collection("patients").document(userID).setData(dict, completion: { (error) in
                    if error == nil{
                        do{
                            CurrentUser.shared = try decode(with: dict)
                            completion(.success(true))
                        }catch{
                            completion(.failure(error.localizedDescription))
                        }
                    }else{
                        completion(.failure(error!.localizedDescription))
                    }
                })
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
                
                
                if device_Token != nil && !device_Token.isEmpty {
                
                let dict = [
                "deviceToken":device_Token]
                
                Firestore.firestore().collection("patients").document(userID).setData(dict, merge: true)
                }
                
                
                
                
                
                Firestore.firestore().collection("patients").document(userID).getDocument(completion: { (snapshot, error) in
                    if let error = error {
                        completion(.failure(error.localizedDescription))
                    }else if let snapshot = snapshot, let dict = snapshot.data(){
                        do{
                            CurrentUser.shared = try decode(with: dict)
                            completion(.success(true))
                        }catch{
                            completion(.failure(error.localizedDescription))
                        }
                    }
                })
                //                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                //                    let dict = snapshot.value as! NSDictionary
                //                    if let name = dict.value(forKey: "name") as? String, let email = dict.value(forKey: "email") as? String,let dob = dict.value(forKey: "dob") as? String{
                //                        User.shared = User(name: name, email: email, dob: dob)
                //                        completion(.success(true))
                //                    }
                //                })
            }
        }
    }
}

func decode<T:Decodable>(with dict:[String: Any]) throws -> T {
    let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
    let decoder = JSONDecoder()
    let model = try decoder.decode(T.self, from: data)
    return model
}
