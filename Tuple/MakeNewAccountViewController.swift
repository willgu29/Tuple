//
//  MakeNewAccountViewController.swift
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class MakeNewAccountViewController: UIViewController, CreateAccountOnServerDelegate, UITextFieldDelegate, CreateFriendsListDelegate {

    var createAccountObject = CreateAccountOnServer()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var phoneNumber: UITextField!
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
        if (textField == phoneNumber)
        {
            [PhoneTextField .textField(textField, shouldChangeCharactersInRange: range, replacementString: string)]
            
        }
        return false;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.resignFirstResponder();
    }
    
    @IBAction func createAccount() {
        if (username.text.isEmpty || firstName.text.isEmpty || lastName.text.isEmpty || email.text.isEmpty || password.text.isEmpty || phoneNumber.text.isEmpty)
        {
            //Alert, please fill out all forms!
        }
        else
        {
            createAccountObject.delegate = self;
            //TODO: Display loading/spinner
            createAccountObject.saveUserWithUsername(username.text, andPassword: password.text, andEmail: email.text, andFirstName: firstName.text, andLastName: lastName.text, andPhoneNumber: phoneNumber.text);
        }
    }
    
    
    //Account delegation -> FriendsList -> Segue VC
    func createAccountSuccess() {
        
        var createFriendsListObject = CreateFriendsList();
        createFriendsListObject.delegate = self;
        createFriendsListObject.createParseFriendsListWithUser(username.text);
    }
    func createAccountWithFailure(error: NSError!) {
    
    }
    
    func createFriendsListSuccess() {
        PFUser.logInWithUsernameInBackground(username.text, password: password.text) { (var user: PFUser!, var error: NSError!) -> Void in
            if ((user) != nil)
            {
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
    func createFriendsListFailure(error: NSError!) {
        
    }
    
    

}
