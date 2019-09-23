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
    
    lazy var datePicker:UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(datePicker:)), for: .valueChanged)
        return datePicker
    }()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dobTextField.inputView = datePicker
    }
    
    @objc func datePickerValueChanged(datePicker:UIDatePicker){
        dobTextField.text = datePicker.date.toString(format: "dd/MM/YYYY")
    }

    @IBAction func signUpTapped(_ sender: UIButton) {
        do{
            try Validator.validateEmptyTextFields(textFields: [nameTextField,emailTextField,passwordTextField,confirmPasswordTextField,dobTextField])
            try Validator.validateEmail(textField: emailTextField)
            try Validator.validatePasswordTextField(textField: passwordTextField)
            try Validator.confirmPasswordTextFields(textField: passwordTextField, confirmTextField: confirmPasswordTextField)
            FirebaseServices.signUp(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, dob: dobTextField.text!) { (result) in
                switch result {
                case .success(_):
                    print("Signed Up Successfully")
                    
                case .failure(let message):
                    print("Signing up Failed")
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
