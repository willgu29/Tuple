//
//  UserProfileViewController.swift
//  Tuple
//
//  Created by William Gu on 2/13/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, PullFromContactsListDelegate {

    var imagePicker = UIImagePickerController()
    @IBOutlet var imagePreview: UIImageView?
    @IBOutlet var submitPictureButton: UIButton?
    var reportBug = ReportBug();
    var delegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    var pullContacts = PullFromContactsList();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitPictureButton?.hidden = true;
        self.imagePreview?.hidden = true;
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePicture(){
        imagePicker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
        imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.Front;
        imagePicker.delegate = self;
        self.presentViewController(imagePicker, animated: true, completion: nil);
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePreview?.image = tempImage;
        CreateProfilePicture.transformImageViewIntoCircle(imagePreview);
        self.submitPictureButton?.hidden = false;
        self.imagePreview?.hidden = false;
        self.dismissViewControllerAnimated(true, completion: nil);
    }
  
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil);

    }
    
    @IBAction func refreshContactList() {
        pullContacts.delegate = self;
        pullContacts.deleteAllFromContactList();
    }
    func contactListDeleteSuccess() {
        pullContacts.checkAuthorizationStatusForContactList();
    }
    func contactListAuthorized() {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.value), 0)) { () -> Void in
            self.pullContacts.fetchAllFromContactsList();
        };
    }
    func contactListAuthorizedFirstTime() {
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.value), 0)) { () -> Void in
            self.pullContacts.fetchAllFromContactsList();
        };
    }
    func contactListDeniedAccess() {
        //Cry
    }
    func contactListFetchSuccess() {
        
        
    }
    func contactListFetchFailure(error: NSError!) {
        
    }
    
    @IBAction func submitPicture() {
        PhotoServer.sendImageToServer(imagePreview?.image);
    }
    
    @IBAction func getPicture() {
        PhotoServer.fetchImageFromServerForUsername(PFUser.currentUser()!.username);
    }
    
    
    @IBAction func logoutButton(){
        PFUser.logOut();
        var introVC = IntroViewController(nibName:"IntroViewController", bundle: nil);
        self.presentViewController(introVC, animated: true, completion: nil);
    }
    
    @IBAction func backButton(){
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func feedbackButton(){
        reportBug.reportBugWithVC(self);
    }
    
}
