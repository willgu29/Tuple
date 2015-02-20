//
//  UserProfileViewController.swift
//  Tuple
//
//  Created by William Gu on 2/13/15.
//  Copyright (c) 2015 William Gu. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker = UIImagePickerController()
    @IBOutlet var imagePreview: UIImageView?
    @IBOutlet var submitPictureButton: UIButton?
    var reportBug = ReportBug();
    var delegate = UIApplication.sharedApplication().delegate as AppDelegate;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        self.submitPictureButton?.hidden = true;
        self.imagePreview?.hidden = true;
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
    
    func imagePickerController(pickGer: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
        var tempImage:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        imagePreview?.image = tempImage;
        CreateProfilePicture.transformImageViewIntoCircle(imagePreview);
        self.submitPictureButton?.hidden = false;
        self.imagePreview?.hidden = false;
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }
    
    @IBAction func submitPicture() {
        SavePhotoToServer.sendImageToServer(imagePreview?.image);
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController!) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func logoutButton(){
        PFUser.logOut();
        delegate.layerClient.deauthenticateWithCompletion { (var success: Bool, var error: NSError!) -> Void in
            
        }
        
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
