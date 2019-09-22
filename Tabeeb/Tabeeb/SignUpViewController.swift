//
//  SignUpViewController.swift
//  Tabeeb
//
//  Created by macbook on 20/09/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UnderLinedTextField!
    @IBOutlet weak var emailTextField: UnderLinedTextField!
    @IBOutlet weak var passwordTextField: UnderLinedTextField!
    @IBOutlet weak var confirmPasswordTextField: UnderLinedTextField!
    @IBOutlet weak var dobTextField: UnderLinedTextField!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func signUpTapped(_ sender: UIButton) {
        do{
            try Validator.validateEmptyTextFields(textFields: [nameTextField,emailTextField,passwordTextField,confirmPasswordTextField,dobTextField])
            try Validator.validateEmail(textField: emailTextField)
            try Validator.validatePasswordTextField(textField: passwordTextField)
            try Validator.confirmPasswordTextFields(textField: passwordTextField, confirmTextField: confirmPasswordTextField)
        }
        catch{
            Alert.show(message: error.localizedDescription)
        }
    }
}
