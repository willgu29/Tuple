//
//  MakeNewAccountViewController.swift
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class MakeNewAccountViewController: UIViewController, UITextFieldDelegate, CreateAccountOnServerDelegate {

    
    var createAccountObject = CreateAccountOnServer();
    
    @IBOutlet var username: UITextField!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        password.secureTextEntry = true;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.resignFirstResponder();
    }
    
    @IBAction func backButton() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func createAccount() {
       
        createAccountObject.delegate = self;
        var success: Bool = createAccountObject.saveUserWithUsername(username.text, andPassword: password.text, andFirstName: firstName.text, andLastName: lastName.text);
        if (success)
        {
            var verificationVC = VerificationStepViewController(nibName:"VerificationStepViewController", bundle:nil);
            verificationVC.createAccountObject = createAccountObject;
            self.presentViewController(verificationVC, animated: true, completion: nil);
        }
        else
        {
            //TODO: Display error
        }
    
    }
    
    func receivedPhoneNumber(phoneNumber:NSString, andEmail email: NSString)
    {
    
    }
    
    //Successful account creation makes a PFUser in Parse Database w/ all necessary information
    func createAccountSuccess() {
        
        PFUser.logInWithUsernameInBackground(username.text, password: password.text) { (var user: PFUser!, var error: NSError!) -> Void in
            if ((user) != nil)
            {
                self.dismissViewControllerAnimated(true, completion: nil);
                //Login success
                var whereWhenVC = WhereWhenViewController(nibName:"WhereWhenViewController", bundle:nil)
                var navigationController = UINavigationController(rootViewController: whereWhenVC);
                self.presentViewController(navigationController, animated: true, completion: nil);
            }
            else
            {
                //Login failure
            }
        }
    }
    func createAccountWithFailure(error: NSError!) {
        
    }
    
   
    
    
    

}
