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
    
    var delegate = UIApplication.sharedApplication().delegate as AppDelegate;
    
    @IBOutlet weak var lbl_count : UILabel!
    @IBOutlet weak var min15: UIButton!
    @IBOutlet weak var min30: UIButton!
    @IBOutlet weak var min1hr: UIButton!
    @IBOutlet weak var min2hr: UIButton!
    @IBOutlet weak var min3hr: UIButton!
    @IBOutlet weak var eventXIB : UITextView!
    @IBOutlet weak var eventLocationXIB : UITextField!
    
  
    
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
        resetAllButtonImages();
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
        var firstName: String = user["firstName"] as String;
        var lastName:String = user["lastName"] as String;
        var hostName = NSString(format: "%@ %@", firstName, lastName)
        delegate.sendData.hostUsername = user.username;
        delegate.sendData.hostName = hostName;
        delegate.sendData.inviterName = hostName; //inviter is also host in this case
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
    @IBAction func timeButtonClicked(var sender: UIButton)
    {
        //TODO: Deselect all
        resetAllButtonImages();
        var buttonImage: UIImage?
        if (sender.tag == 0)
        {
            delegate.sendData.minutesTillMeetup = 15;
            buttonImage = UIImage(named:"15HMinButton.png");
        }
        else if (sender.tag == 1)
        {
            delegate.sendData.minutesTillMeetup = 30;
            buttonImage = UIImage(named: "30HMinButton.png");
        }
        else if (sender.tag == 2)
        {
            delegate.sendData.minutesTillMeetup = 60;
            buttonImage = UIImage(named: "1hrButtonH.png");
        }
        else if (sender.tag == 3)
        {
            delegate.sendData.minutesTillMeetup = 120;
            buttonImage = UIImage(named: "2hrButtonH.png");
        }
        else if (sender.tag == 4)
        {
            delegate.sendData.minutesTillMeetup = 180;
            buttonImage = UIImage(named: "3hrButtonH.png");
        }
        sender.setImage(buttonImage, forState: UIControlState.Normal);

        
    }
    
    @IBAction func checkInvites(){
        //TODO: not using the navigation controller
        delegate.sendData.currentUsername = PFUser.currentUser().username;
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
        var len =  countElements(textView.text)
        lbl_count.text = NSString(format: "%i", 70-len)
        
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (countElements(text) == 0)
        {
            if (countElements(textView.text) != 0)
            {
                return true;
            }
        }
        else if (countElements(textView.text) > 69)
        {
            return false;
        }
        return true;
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func resetAllButtonImages(){
        var buttonImage0 = UIImage(named: "15MinButton.png");
        var buttonImage1 = UIImage(named: "30MinButton.png");
        var buttonImage2 = UIImage(named: "1hrButton.png");
        var buttonImage3 = UIImage(named: "2hrButton.png");
        var buttonImage4 = UIImage(named: "3hrButton.png");

        min15.setImage(buttonImage0, forState: UIControlState.Normal);
        min30.setImage(buttonImage1, forState: UIControlState.Normal);
        min1hr.setImage(buttonImage2, forState: UIControlState.Normal);
        min2hr.setImage(buttonImage3, forState: UIControlState.Normal);
        min3hr.setImage(buttonImage4, forState: UIControlState.Normal);

    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        eventXIB.resignFirstResponder();
        eventLocationXIB.resignFirstResponder();
    }

}
