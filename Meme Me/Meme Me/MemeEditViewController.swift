//
//  MemeEditViewController.swift
//  Pick and Image
//
//  Created by Daniel Riehs on 3/13/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate
{

    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        
        //If this number is positive, the text foreground color does not display.
        NSStrokeWidthAttributeName : -3.0,
    ]
    
    
    @IBAction func pickAnImage(sender: AnyObject) {
        launchImagePicker(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    
    @IBAction func takePicture(sender: AnyObject) {
        launchImagePicker(UIImagePickerControllerSourceType.Camera)
    }
    
    
    //Except for the source type, the process for launching the camera to use a newly-taken photo is identical to the process for picking an image from the album.
    func launchImagePicker(souceType: UIImagePickerControllerSourceType)
    {
        let source = souceType
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    //When the meme is shared, it is also saved in the memes array.
    @IBAction func shareMeme(sender: AnyObject) {

        let memedImage = self.generateMemedImage()
        
        let meme = Meme(topText: self.topText.text, bottomText: self.bottomText.text, image: self.imagePickerView.image!, memedImage: memedImage)
        
        (UIApplication.sharedApplication().delegate as AppDelegate).memes.append(meme)
        
        let activityViewController = UIActivityViewController(
            activityItems: [memedImage as UIImage],
            applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imagePickerView.image = image
                
                //The Share button can be shown once an image is chosen.
                shareButton.enabled = true
            }
            self.dismissViewControllerAnimated(true, completion: nil)
    }


    override func viewWillAppear(animated: Bool) {
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable    (UIImagePickerControllerSourceType.Camera)

        //MemeEditViewController needs to be notified when the keyboard is shown in case screen view needs to be moved out of the way.
        self.subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.unsubscribeFromKeyboardNotifications()
    }
    
    
    override func viewDidLoad() {
        
        self.topText.delegate = self
        self.bottomText.delegate = self
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        
        //1 = Center
        topText.textAlignment = NSTextAlignment(rawValue: 1)!
        bottomText.textAlignment = NSTextAlignment(rawValue: 1)!
        
        topText.text = "EDIT TOP TEXT"
        bottomText.text = "EDIT BOTTOM TEXT"
        
        //The share button cannot be enabled until after an image is chosen.
        shareButton.enabled = false
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //This clears the default text.
        textField.text = ""
    }
    
    
    //Text is processed when the return key is pressed.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    //Called in viewWillAppear.
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //Called in viewWillDisappear.
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        //The keyboard only slides away if the top text field is edited.
        if bottomText.editing == true
        {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
        //The keyboard only slides away if the top text field is edited.
        if bottomText.editing == true
        {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        //The vertical slide distance is set dynamically depending on the height of the keyboard.
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return keyboardSize.CGRectValue().height
    }
    
    
    func generateMemedImage() -> UIImage
    {
        //The top navigation bar and bottom toolbar will not be included in the meme image.
        self.topBar.hidden = true
        self.bottomBar.hidden = true

        //Saves the screen view as memedImage.
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Unhiding the navigation bar and toolbar.
        self.topBar.hidden = false
        self.bottomBar.hidden = false
        
        return memedImage
    }
}

