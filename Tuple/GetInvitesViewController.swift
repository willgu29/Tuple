//
//  InvitesViewController.swift
//  Tuple
//
//  Created by William Gu on 2/8/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class GetInvitesViewController: UIViewController {

    var delegate = UIApplication.sharedApplication().delegate as AppDelegate;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton() {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
    }

}
