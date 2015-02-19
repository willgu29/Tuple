//
//  UserProfileViewController.swift
//  Tuple
//
//  Created by William Gu on 2/13/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    var reportBug = ReportBug();
    var delegate = UIApplication.sharedApplication().delegate as AppDelegate;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func logoutButton(){
        PFUser.logOut();
        delegate.layerClient.deauthenticateWithCompletion { (var success: Bool, var error: NSError!) -> Void in
            
        }
        
        var introVC = IntroViewController(nibName:"IntroViewController", bundle: nil);
        self.presentViewController(introVC, animated: true, completion: nil);
    }
    
    @IBAction func backButton(){
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func feedbackButton(){
        reportBug.reportBugWithVC(self);
    }
    
}
