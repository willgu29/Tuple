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
        delegate.sendData.minutesTillMeetup = -1;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorCheckSuccess() -> Bool {
        if (delegate.sendData.minutesTillMeetup == -1)
        {
            var alert = UIAlertView(title: "What? Where? When?", message: "Please select when you want to eat.", delegate: nil, cancelButtonTitle: "Sure")
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
    
    func saveDate(){
        var date = Converter.convertTimeMinutesToDate(delegate.sendData.minutesTillMeetup);
        var dateLocal = Converter.convertDateToCurrentTimeZone(date);
        delegate.sendData.eventTime = Converter.formatDateTo12HoursPmAm(date)
    }
    func saveHostName()
    {
        var user = PFUser.currentUser();
        var firstName:String = user?.objectForKey("firstName") as! String;
        var lastName:String = user?.objectForKey("lastName") as! String;
        var hostName = NSString(format: "%@ %@", firstName, lastName)
        delegate.sendData.hostUsername = user!.username;
        delegate.sendData.hostName = hostName as String;
        delegate.sendData.inviterName = hostName as String; //inviter is also host in this case
    }
    
    func saveLocation() {
        delegate.sendData.event = eventXIB.text;
    }
    
    func saveEvent() {
        delegate.sendData.eventLocation = eventLocationXIB.text;
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
            saveDate();
            saveHostName();
            saveLocation();
            saveEvent();
            delegate.sendData.clientType = 1;
            var sendInviteVC = SendInvitesViewController(nibName: "SendInvitesViewController", bundle: nil);
            self.navigationController?.pushViewController(sendInviteVC, animated: true);
        }
    }

    @IBAction func checkInvites(){
        //TODO: not using the navigation controller
        delegate.sendData.currentUsername = PFUser.currentUser()!.username;
        delegate.sendData.clientType = 2;
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
