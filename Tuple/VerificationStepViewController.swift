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

class VerificationStepViewController: UIViewController {
    
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
            //TODO: Alert!
        }
    }
    
    
}
