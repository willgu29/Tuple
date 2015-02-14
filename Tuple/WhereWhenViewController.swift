//
//  WhereWhenViewController.swift
//  Degrees
//
//  Created by William Gu on 2/7/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class WhereWhenViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var delegate = UIApplication.sharedApplication().delegate as AppDelegate;
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var diningHallPicker: UIPickerView!
    var dataSourcePicker: NSArray = ["No Preference", "De Neve", "B Plate", "Feast", "Covel", "Rende", "Cafe 1919", "B Cafe"]
    
    @IBOutlet weak var min5: UIButton!
    @IBOutlet weak var min15: UIButton!
    @IBOutlet weak var min30: UIButton!
    @IBOutlet weak var min45: UIButton!
    @IBOutlet weak var min60: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true;

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
            //TODO: Alert, please click a time!
            return false;
        }
        return true;
    }
    
    func saveDate(){
        var date = TimeNumberConvert.convertTimeMinutesToDate(delegate.sendData.minutesTillMeetup);
        var dateLocal = TimeNumberConvert.convertDateToCurrentTimeZone(date);
        delegate.sendData.theTimeToEat = TimeNumberConvert.formatDateTo12HoursPmAm(date)
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
    //IBActions

    @IBAction func sendInvites() {
        if (errorCheckSuccess() == true)
        {
            saveDate();
            saveHostName();
            delegate.sendData.clientType = 1;
            var sendInviteVC = SendInvitesViewController(nibName: "SendInvitesViewController", bundle: nil);
            self.navigationController?.pushViewController(sendInviteVC, animated: true);
        }
    }
    @IBAction func timeButtonClicked(var sender: UIButton)
    {
        //TODO: Deselect all
//        resetAllButtonImages();
        
        if (sender.tag == 0)
        {
            delegate.sendData.minutesTillMeetup = 5;
            var buttonImage = UIImage(contentsOfFile: "5hMinButton.png");
            sender.setImage(buttonImage, forState: UIControlState.Normal);
        }
        else if (sender.tag == 1)
        {
            delegate.sendData.minutesTillMeetup = 15;
            var buttonImage = UIImage(contentsOfFile: "15HMinButton.png");
            sender.setImage(buttonImage, forState: UIControlState.Normal);
        }
        else if (sender.tag == 2)
        {
            delegate.sendData.minutesTillMeetup = 30;
            var buttonImage = UIImage(contentsOfFile: "30HMinButton.png");
            min30.setImage(buttonImage, forState: UIControlState.Normal);
        }
        else if (sender.tag == 3)
        {
            delegate.sendData.minutesTillMeetup = 45;
            var buttonImage = UIImage(contentsOfFile: "45HMinButton.png");
            min45.setImage(buttonImage, forState: UIControlState.Normal);
        }
        else if (sender.tag == 4)
        {
            delegate.sendData.minutesTillMeetup = 60;
            var buttonImage = UIImage(contentsOfFile: "60HMinButton.png");
            min60.setImage(buttonImage, forState: UIControlState.Normal);
        }
     
        
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
    
 
 
    
    //Dining Hall Picker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Save dining hall
        NSLog("Picker row: %d", row);
        delegate.sendData.diningHallInt = Int32(row);
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let dataString = dataSourcePicker.objectAtIndex(row) as String;
        return NSAttributedString(string: dataString, attributes: [NSForegroundColorAttributeName:UIColor.blackColor()])
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSourcePicker.count;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    //*********************
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func resetAllButtonImages(){
        var buttonImage0 = UIImage(contentsOfFile: "5MinButton.png");
        var buttonImage1 = UIImage(contentsOfFile: "15MinButton.png");
        var buttonImage2 = UIImage(contentsOfFile: "30MinButton.png");
        var buttonImage3 = UIImage(contentsOfFile: "45MinButton.png");
        var buttonImage4 = UIImage(contentsOfFile: "60MinButton.png");

        min5.setBackgroundImage(buttonImage0, forState: UIControlState.Normal);
        min15.setBackgroundImage(buttonImage1, forState: UIControlState.Normal);
        min30.setBackgroundImage(buttonImage2, forState: UIControlState.Normal);
        min45.setBackgroundImage(buttonImage3, forState: UIControlState.Normal);
        min60.setBackgroundImage(buttonImage4, forState: UIControlState.Normal);

    }

}
