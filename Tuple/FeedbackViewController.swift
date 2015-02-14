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
    var ratingCounter = -1
    @IBOutlet var explainerLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var rateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        messageLabel.alpha = 0;
        explainerLabel.alpha = 1;
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
    
    //Feedback Button Counter
    @IBAction func rateExperience(sender: UIButton){
        ratingCounter++;
        if (ratingCounter == 0)
        {
            var buttonImage = UIImage(named:"Rating1Click.png");
            sender.setImage(buttonImage, forState: UIControlState.Normal);
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                self.explainerLabel.alpha = 0;
            })
            UIView.animateWithDuration(2, animations: { () -> Void in
                self.messageLabel.alpha = 1
                self.messageLabel.text = "no love"
            })
        }
        else if (ratingCounter == 1)
        {
            var buttonImage = UIImage(named:"Rating2Click.png");
            sender.setImage(buttonImage, forState: UIControlState.Normal);
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.messageLabel.alpha = 0;
            })
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.messageLabel.alpha = 1
                self.messageLabel.text = ":("
            })
        }
        else if (ratingCounter == 2)
        {
            var buttonImage = UIImage(named:"Rating3Click.png");
            sender.setImage(buttonImage, forState: UIControlState.Normal);
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.messageLabel.alpha = 0;
            })
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.messageLabel.alpha = 1
                self.messageLabel.text = "it was... okay"
            })
        }
        else if (ratingCounter == 3)
        {
            var buttonImage = UIImage(named:"Rating4Click.png");
            sender.setImage(buttonImage, forState: UIControlState.Normal);
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.messageLabel.alpha = 0;
            })
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.messageLabel.alpha = 1
                self.messageLabel.text = "just one more"
            })        }
        else if (ratingCounter == 4)
        {
            var buttonImage = UIImage(named:"Rating5Click.png");
            sender.setImage(buttonImage, forState: UIControlState.Normal);
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.messageLabel.alpha = 0;
            })
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.messageLabel.alpha = 1
                self.messageLabel.text = "*fist bump*"
            })
        }
        else if (ratingCounter == 5)
        {
            var buttonImage = UIImage(named:"WhiteRingWShadow.png");
            sender.setImage(buttonImage, forState: UIControlState.Normal);
            ratingCounter = -1
            UIView.animateWithDuration(1.5, animations: { () -> Void in
                self.messageLabel.alpha = 0;
                self.explainerLabel.alpha = 1;
            })
        }
    }
    
}
