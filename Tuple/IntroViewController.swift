//
//  IntroViewController.swift
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if ((PFUser.currentUser()) != nil)
        {
            var whereWhenVC = WhereWhenViewController(nibName:"WhereWhenViewController", bundle:nil);
            var navVC = UINavigationController(rootViewController: whereWhenVC);
            self.presentViewController(navVC, animated: true, completion: nil);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //IBACTIONS .....
    
    @IBAction func loginButton() {
        loginToParse();
    }
    
    @IBAction func makeNewAccount() {
        var makeAccountVC = MakeNewAccountViewController(nibName:"MakeNewAccountViewController", bundle: nil)
        self.presentViewController(makeAccountVC, animated: true, completion: nil);
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        UIApplication.sharedApplication().sendAction("resignFirstResponder", to: nil, from: nil, forEvent: nil)
    }
    
    func loginToParse(){
        if (username.text.isEmpty || password.text.isEmpty)
        {
            var alert = UIAlertView(title: "Oops!", message: "Please enter a username and password", delegate: nil, cancelButtonTitle: "Okay!")
            alert.show()
        }
        else
        {
            
            var loginUsername = username.text.stringByReplacingOccurrencesOfString(" ", withString: "");
            var loginPassword = password.text.stringByReplacingOccurrencesOfString(" ", withString: "");
            PFUser.logInWithUsernameInBackground(loginUsername, password: loginPassword, block: { (var user: PFUser!, var error: NSError!) -> Void in
                if (user != nil)
                {
                    self.segueToMainVC();
                }
                else
                {
                    if (error.code == 101)
                    {
                        var alert = UIAlertView(title: "Uh oh...", message: "You've entered an incorrect username/password", delegate: nil, cancelButtonTitle: "Alright!")
                        alert.show()
                    }
                    else
                    {
                        var alert = UIAlertView(title: "We couldn't login...", message: "Please check your internet.", delegate: nil, cancelButtonTitle: "Sounds good")
                        alert.show()
                    }
                    
                }
            })
        }
    }
    
    func segueToMainVC(){
        var whereWhenVC = WhereWhenViewController(nibName:"WhereWhenViewController", bundle:nil)
        var navigationController = UINavigationController(rootViewController: whereWhenVC);
        self.presentViewController(navigationController, animated: true, completion: nil);
    }
    
    //**********************
    
    

}
