//
//  MemeEditViewController.swift
//  Meme Me
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
		NSAttributedString.Key.strokeColor.rawValue : UIColor.black,
		NSAttributedString.Key.foregroundColor : UIColor.white,
		NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,

		//If this number is positive, the text foreground color does not display.
		NSAttributedString.Key.strokeWidth : -3.0,
	] as! [String : Any]


	//Defining the file path where the archived data will be stored by the NSKeyedArchiver.
	var filePath : String {
		let manager = FileManager.default
		let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
		return url!.appendingPathComponent("memesArray").path
	}


	@IBAction func pickAnImage(_ sender: AnyObject) {
		launchImagePicker(UIImagePickerController.SourceType.photoLibrary)
	}


	@IBAction func takePicture(_ sender: AnyObject) {
		launchImagePicker(UIImagePickerController.SourceType.camera)
	}


	//Except for the source type, the process for launching the camera to use a newly-taken photo is identical to the process for picking an image from the album.
	func launchImagePicker(_ souceType: UIImagePickerController.SourceType)
	{
		let source = souceType
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = source
		present(imagePicker, animated: true, completion: nil)
	}


	//When the meme is shared, it is also saved in the memes array.
	@IBAction func shareMeme(_ sender: AnyObject) {

		let memedImage = generateMemedImage()

		let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage)

		//Save the meme into the memes array.
		Memes.sharedInstance().memes.append(meme)

		//Saving the array to the file.
		NSKeyedArchiver.archiveRootObject(Memes.sharedInstance().memes, toFile: filePath)

		let activityViewController = UIActivityViewController(
			activityItems: [memedImage as UIImage],
			applicationActivities: nil)

		present(activityViewController, animated: true, completion: nil)

	}


	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

			if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
				imagePickerView.image = image

				//The Share button can be shown once an image is chosen.
				shareButton.isEnabled = true
			}
			dismiss(animated: true, completion: nil)
	}


	override func viewWillAppear(_ animated: Bool) {
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable	(UIImagePickerController.SourceType.camera)

		//MemeEditViewController needs to be notified when the keyboard is shown in case screen view needs to be moved out of the way.
		subscribeToKeyboardNotifications()
	}


	override func viewWillDisappear(_ animated: Bool) {
		unsubscribeFromKeyboardNotifications()
	}


	override func viewDidLoad() {

		//Unarchiving the saved array.
		if let memesArray = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Meme] {
			Memes.sharedInstance().memes = memesArray
		}

		topText.delegate = self
		bottomText.delegate = self

		topText.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)
		bottomText.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)

		//1 = Center
		topText.textAlignment = NSTextAlignment(rawValue: 1)!
		bottomText.textAlignment = NSTextAlignment(rawValue: 1)!

		topText.text = "EDIT TOP TEXT"
		bottomText.text = "EDIT BOTTOM TEXT"

		//The share button cannot be enabled until after an image is chosen.
		shareButton.isEnabled = false
	}


	func textFieldDidBeginEditing(_ textField: UITextField) {
		//This clears the default text.
		textField.text = ""
	}


	//Text is processed when the return key is pressed.
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true;
	}


	//Called in viewWillAppear.
	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(MemeEditViewController.keyboardWillShow(_:))	, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(MemeEditViewController.keyboardWillHide(_:))	, name: UIResponder.keyboardWillHideNotification, object: nil)
	}


	//Called in viewWillDisappear.
	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name:
			UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name:
			UIResponder.keyboardWillHideNotification, object: nil)
	}


	@objc func keyboardWillShow(_ notification: Notification) {
		//The keyboard only slides away if the top text field is edited.
		if bottomText.isEditing == true
		{
			view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}


	@objc func keyboardWillHide(_ notification: Notification) {
		//The keyboard only slides away if the top text field is edited.
		if bottomText.isEditing == true
		{
			view.frame.origin.y += getKeyboardHeight(notification)
		}
	}


	func getKeyboardHeight(_ notification: Notification) -> CGFloat {
		//The vertical slide distance is set dynamically depending on the height of the keyboard.
		let userInfo = (notification as NSNotification).userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.cgRectValue.height
	}


	func generateMemedImage() -> UIImage
	{
		//The top navigation bar and bottom toolbar will not be included in the meme image.
		topBar.isHidden = true
		bottomBar.isHidden = true

		//Saves the screen view as memedImage.
		UIGraphicsBeginImageContext(view.frame.size)
		view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
		let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		//Unhiding the navigation bar and toolbar.
		topBar.isHidden = false
		bottomBar.isHidden = false

		return memedImage
	}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
