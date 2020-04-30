//
//  PasswordResetViewController.swift
//  Tabeeb
//
//  Created by Tamim Dari on 4/24/20.
//  Copyright © 2020 SZABIST. All rights reserved.
//

import UIKit
import Firebase


class PasswordResetViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UnderLinedTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

   
    @IBAction func SendButton(_ sender: Any) {
        
        
        do{
            try Validator.validateEmptyTextFields(textFields: [EmailTextField])
            try Validator.validateEmail(textField: EmailTextField)
            
            Auth.auth().sendPasswordReset(withEmail: EmailTextField.text!) { (error) in
                if let error = error{
                    Alert.show(message: error.localizedDescription)
                }
                else{
                    Alert.show(message: "Check your email to Reset Password")
                    self.EmailTextField.text = ""
                }
            }
            
            
          }
          catch{
              let _error = error as! FieldError
              Alert.show(message: _error.localizedDescription)
          }
        
    }
    
}
