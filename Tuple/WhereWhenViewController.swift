//
//  WhereWhenViewController.swift
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class WhereWhenViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    
    let PLACEHOLDER_TEXTVIEWTEXT = "What do you wanna do?";
    
    var delegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    @IBOutlet weak var lbl_count : UILabel!
    @IBOutlet weak var eventXIB : UITextView!
    @IBOutlet weak var eventLocationXIB : UITextField!
    @IBOutlet weak var eventTimeXIB : UITextField!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup Layer
        self.navigationController?.navigationBarHidden = true;
        
        var imageLayer = eventXIB.layer;
        imageLayer.cornerRadius = 10;
        imageLayer.borderWidth = 1;
        imageLayer.borderColor = UIColor.lightGrayColor().CGColor;

    }
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorCheckSuccess() -> Bool {
        if (eventTimeXIB.text.isEmpty)
        {
            var alert = UIAlertView(title: "What? Where? When?", message: "Please specify when you want to meet.", delegate: nil, cancelButtonTitle: "Sure")
            alert.show()
            return false;
        }
        else if (eventLocationXIB.text.isEmpty)
        {
            var alert = UIAlertView(title: "Hm...", message: "Please enter a location!", delegate: nil, cancelButtonTitle: "Sure!");
            alert.show();
            return false;
        }
        else if (eventXIB.text == PLACEHOLDER_TEXTVIEWTEXT)
        {
            var alert = UIAlertView(title: "Huh..", message: "Please enter what you want to do!", delegate: nil, cancelButtonTitle:"Oops!");
            alert.show();
            return false;
        }
        return true;
    }

    
    
    //IBActions

    @IBAction func sendInvites() {
       
        if (!ParseDatabase.getPhoneVerificationStatusCurrentUser())
        {
            var alert = UIAlertView(title: "Tuple Closed Beta", message: "Interested in testing? Email us at support@tupleapp.com with proof that you're a Bruin!", delegate: nil, cancelButtonTitle: "Okay!")
            alert.show()
            return;
        }
        
        
        if (errorCheckSuccess() == true)
        {
            var sendInviteVC = SendInvitesViewController(nibName: "SendInvitesViewController", bundle: nil);
            self.navigationController?.pushViewController(sendInviteVC, animated: true);
        }
    }

    @IBAction func checkInvites(){
        var getInvitesVC = GetInvitesViewController(nibName:"GetInvitesViewController", bundle: nil);
        self.navigationController?.pushViewController(getInvitesVC, animated: true)
    }
    
    @IBAction func profileButton(){
        var userVC = UserProfileViewController(nibName:"UserProfileViewController", bundle:nil);
        self.presentViewController(userVC, animated: true, completion: nil);
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.text == PLACEHOLDER_TEXTVIEWTEXT)
        {
            textView.text = "";
            textView.textColor = UIColor.blackColor()
        }
        textView.becomeFirstResponder();
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text.isEmpty)
        {
            textView.text = PLACEHOLDER_TEXTVIEWTEXT;
            textView.textColor = UIColor.lightGrayColor();
        }
        textView.resignFirstResponder();
    }
    func textViewDidChange(textView: UITextView) {
        var len =  count(textView.text)
        lbl_count.text = NSString(format: "%i", 70-len) as String
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (count(text) == 0)
        {
            if (count(textView.text) != 0)
            {
                return true;
            }
        }
        else if (count(textView.text) > 69)
        {
            return false;
        }
        return true;
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        eventXIB.resignFirstResponder();
        eventLocationXIB.resignFirstResponder();
    }

}
