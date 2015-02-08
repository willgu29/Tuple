//
//  FeedbackViewController.swift
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    var reportBug = ReportBug();

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doItAgainButton() {
        self.navigationController?.popToRootViewControllerAnimated(true);
    }
    
    @IBAction func giveFeedbackButton() {
        reportBug.reportBugWithVC(self);
    }
    
}
