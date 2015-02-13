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
    @IBAction func timeButton5Clicked()
    {
        delegate.sendData.minutesTillMeetup = 5;
    }
    @IBAction func timeButton15Clicked()
    {
        delegate.sendData.minutesTillMeetup = 15;
    }
    @IBAction func timeButton30Clicked()
    {
        delegate.sendData.minutesTillMeetup = 30;
    }
    @IBAction func timeButton45Clicked()
    {
        delegate.sendData.minutesTillMeetup = 45;
    }
    @IBAction func timeButton60Clicked()
    {
        delegate.sendData.minutesTillMeetup = 60;

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

}
