//
//  IntroViewController.swift
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

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
        var whereWhenVC = WhereWhenViewController(nibName:"WhereWhenViewController", bundle:nil)
        var navigationController = UINavigationController(rootViewController: whereWhenVC);
        self.presentViewController(navigationController, animated: true, completion: nil);
    }
    
    @IBAction func makeNewAccount() {
        var makeAccountVC = MakeNewAccountViewController(nibName:"MakeNewAccountViewController", bundle: nil)
        self.presentViewController(makeAccountVC, animated: true, completion: nil);
    }
    
    //**********************
    
    

}
