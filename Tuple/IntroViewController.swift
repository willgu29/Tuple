//
//  IntroViewController.swift
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    
    func loginToParse(){
        if (username.text.isEmpty || password.text.isEmpty)
        {
            
        }
        else
        {
            PFUser.logInWithUsernameInBackground(username.text, password: password.text, block: { (var user: PFUser!, var error: NSError!) -> Void in
                if (user != nil)
                {
                    self.segueToMainVC();
                }
                else
                {
                    //TODO: Display alert or animation
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
