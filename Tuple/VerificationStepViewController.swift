//
//  VerificationStepViewController.swift
//  Tuple
//
//  Created by William Gu on 2/13/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

protocol VerificationStepViewControllerDelegate
{
    
}

class VerificationStepViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var phoneNumber : UITextField!
    @IBOutlet var emailAddress : UITextField!
    var createAccountObject : CreateAccountOnServer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)

    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (textField == phoneNumber)
        {
            PhoneTextField.textField(textField, shouldChangeCharactersInRange: range, replacementString: string)
            return false;
        }
        return true;
    }
    
    @IBAction func enterButton() {
        var success: Bool = createAccountObject.savePhoneNumber(phoneNumber.text, andEmail: emailAddress.text);
        if (success)
        {
            createAccountObject.createAccount();
        }
        else
        {
            var alert = UIAlertView(title: "Hm...", message: "Please enter a phone number and email address.", delegate: nil, cancelButtonTitle: "On it!")
            alert.show()
        }
    }
    
    
}
