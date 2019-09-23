//
//  LoginViewController.swift
//  Tabeeb
//
//  Created by macbook on 20/09/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UnderLinedTextField!
    
    @IBOutlet weak var passwordTextField: UnderLinedTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        do{
            try Validator.validateEmptyTextFields(textFields: [emailTextField,passwordTextField])
            try Validator.validateEmail(textField: emailTextField)
            try Validator.validatePasswordTextField(textField: passwordTextField)
            FirebaseServices.login(email: emailTextField.text!, password: passwordTextField.text!) { (result) in
                switch result {
                case .success(_):
                    print("Signedin Successfully")
                case .failure(let message):
                    print(message)
                    Alert.show(message: message)
                }
            }
        }
        catch{
            let _error = error as! FieldError
            Alert.show(message: _error.localizedDescription)
        }
    }
}

