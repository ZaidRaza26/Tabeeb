//
//  Validator.swift
//  Tabeeb
//
//  Created by macbook on 20/09/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit

protocol ErrorProtocol: Error {
    var localizedTitle: String { get }
    var localizedDescription: String { get }
}

protocol FieldErrorProtocol: ErrorProtocol{
    var textField:UITextField { get }
}

/**
 Field Error is used in TextField validations. The error will contain the textfield which caused the error.
 */
struct FieldError: FieldErrorProtocol {
    
    var localizedTitle: String
    var localizedDescription: String
    var textField: UITextField
    
    init(localizedTitle: String? = "Error", localizedDescription: String, textField:UITextField) {
        self.localizedTitle = localizedTitle!
        self.localizedDescription = localizedDescription
        self.textField=textField
    }
}

class Validator: NSObject {
    
    enum Rule{
        case required([UITextField])
        case validEmail(UITextField)
        case password(UITextField)
        case confirm(UITextField, UITextField)
    }
    
    class func validate(rules:Rule...) throws {
        for rule in rules{
            switch rule{
            case let .required(textFields):
                try validateEmptyTextFields(textFields: textFields)
            case let .validEmail(textField):
                try validateEmail(textField: textField)
            case let .password(textField):
                try validatePasswordTextField(textField: textField)
            case let .confirm(textField, confirmTextField):
                try confirmPasswordTextFields(textField: textField, confirmTextField: confirmTextField)
            }
        }
    }
    
    /**
     Validates Empty Text fields
     
     -parameter textFields: Array of textfields to validate
     -returns: A field error if any text field is empty.
     */
    class func validateEmptyTextFields(textFields:[UITextField]) throws{
        for textField in textFields{
            if(textField.text!.isEmpty){
                throw FieldError(localizedDescription: "Textfields cannot be empty", textField: textField)
            }
        }
    }
    
    /**
     Validates Password text field, checks if character count is greater than 6
     
     -parameter textField: Textfield to validate
     -returns: A field error if any case is not satisfied
     */
    class func validatePasswordTextField(textField:UITextField) throws{
        if(textField.text!.count < 6){
            throw FieldError(localizedDescription: "Password cannot be less then 6 characters", textField: textField)
        }
    }
    
    /**
     Validates Email text field, checks if email is in the right format
     
     -parameter textFields: Textfield to validate
     -returns: A field error if email format is wrong
     */
    class func validateEmail(textField:UITextField) throws{
        let emailRegex = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        if (textField.text?.range(of: emailRegex, options: .regularExpression) == nil){
            throw FieldError(localizedDescription: "Email is not correct", textField: textField)
        }
    }
    
    /**
     Validates Password and Confirm password Text fields
     
     -parameter textFields: Array of textfields to compare
     -returns: A field error if text does not match.
     */
    class func confirmPasswordTextFields(textField:UITextField, confirmTextField:UITextField) throws{
        
        if(textField.text != confirmTextField.text){
            throw FieldError(localizedDescription: "Passwords do not match", textField: textField)
        }
    }
}
