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
        delegate.preSendData.minutesTillMeetup = -1;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func errorCheckSuccess() -> Bool {
        if (delegate.preSendData.minutesTillMeetup == -1)
        {
            //TODO: Alert, please click a time!
            return false;
        }
        return true;
    }
    
    //IBActions
    @IBAction func sendInvites() {
        if (errorCheckSuccess() == true)
        {
            var sendInviteVC = SendInvitesViewController(nibName: "SendInvitesViewController", bundle: nil);
            self.navigationController?.pushViewController(sendInviteVC, animated: true);
        }
    }
    @IBAction func timeButtonNowClicked()
    {
        delegate.preSendData.minutesTillMeetup = 0;
    }
    @IBAction func timeButton15Clicked()
    {
        delegate.preSendData.minutesTillMeetup = 15;
    }
    @IBAction func timeButton30Clicked()
    {
        delegate.preSendData.minutesTillMeetup = 30;
    }
    @IBAction func timeButton45Clicked()
    {
        delegate.preSendData.minutesTillMeetup = 45;
    }
    @IBAction func timeButton60Clicked()
    {
        delegate.preSendData.minutesTillMeetup = 60;

    }
    
    @IBAction func checkInvites(){
        //TODO: not using the navigation controller
        var getInvitesVC = GetInvitesViewController(nibName:"GetInvitesViewController", bundle: nil);
        self.presentViewController(getInvitesVC, animated: true, completion: nil);
    }
    
    @IBAction func addFriends(){
        var addFriendsVC = AddFriendsViewController(nibName:"AddFriendsViewController", bundle: nil);
        self.navigationController?.pushViewController(addFriendsVC, animated: true);
    }
    
    //Dining Hall Picker
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Save dining hall
        NSLog("Picker row: %d", row);
        delegate.preSendData.diningHallInt = Int32(row);
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
