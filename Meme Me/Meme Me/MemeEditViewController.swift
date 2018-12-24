//
//  MemeEditViewController.swift
//  Meme Me
//
//  Created by Daniel Riehs on 3/13/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import UIKit
import CoreData

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
		NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
		NSAttributedStringKey.foregroundColor : UIColor.white,
		NSAttributedStringKey.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,

		//If this number is positive, the text foreground color does not display.
		NSAttributedStringKey.strokeWidth : -3.0,
		] as! [String : Any]


	@IBAction func pickAnImage(_ sender: AnyObject) {
		launchImagePicker(UIImagePickerControllerSourceType.photoLibrary)
	}


	@IBAction func takePicture(_ sender: AnyObject) {
		launchImagePicker(UIImagePickerControllerSourceType.camera)
	}

	//Useful for saving data into the Core Data context.
	var sharedContext: NSManagedObjectContext {
		return CoreDataStackManager.sharedInstance().managedObjectContext
	}

	//Except for the source type, the process for launching the camera to use a newly-taken photo is identical to the process for picking an image from the album.
	func launchImagePicker(_ souceType: UIImagePickerControllerSourceType)
	{
		let source = souceType
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = source
		present(imagePicker, animated: true, completion: nil)
	}


	//When the meme is shared, it is also saved in the memes array.
	@IBAction func shareMeme(_ sender: AnyObject) {

		CoreDataStackManager.sharedInstance().saveContext()

		let memedImage = generateMemedImage()

		let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, image: imagePickerView.image!, memedImage: memedImage, context: sharedContext)

		//Save the meme into the memes array.
		Memes.sharedInstance().memes.append(meme)

		//Now that the meme has been saved into the array, the Core Data context is saved.
		CoreDataStackManager.sharedInstance().saveContext()

		let activityViewController = UIActivityViewController(
			activityItems: [memedImage as UIImage],
			applicationActivities: nil)

		present(activityViewController, animated: true, completion: nil)

	}


	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
		if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
			imagePickerView.image = image
			
			//The Share button can be shown once an image is chosen.
			shareButton.isEnabled = true
		}
		dismiss(animated: true, completion: nil)
	}


	override func viewWillAppear(_ animated: Bool) {
		cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable	(UIImagePickerControllerSourceType.camera)

		//MemeEditViewController needs to be notified when the keyboard is shown in case screen view needs to be moved out of the way.
		subscribeToKeyboardNotifications()
	}


	override func viewWillDisappear(_ animated: Bool) {
		unsubscribeFromKeyboardNotifications()
	}


	override func viewDidLoad() {

		//This loads memes from Core Data into the memes array.
		Memes.sharedInstance().memes = fetchAllMemes()

		topText.delegate = self
		bottomText.delegate = self

		topText.defaultTextAttributes = memeTextAttributes
		bottomText.defaultTextAttributes = memeTextAttributes

		//1 = Center
		topText.textAlignment = NSTextAlignment(rawValue: 1)!
		bottomText.textAlignment = NSTextAlignment(rawValue: 1)!

		topText.text = "EDIT TOP TEXT"
		bottomText.text = "EDIT BOTTOM TEXT"

		//The share button cannot be enabled until after an image is chosen.
		shareButton.isEnabled = false
	}

	
	func fetchAllMemes() -> [Meme] {
		let error: NSErrorPointer? = nil
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Meme")
		let results: [AnyObject]?
		do {
			results = try sharedContext.fetch(fetchRequest)
		} catch let error1 as NSError {
			error??.pointee = error1
			results = nil
		}
		
		if error != nil {
			print("Error in fetchAllMemes(): \(String(describing: error))")
		}
		
		return results as! [Meme]
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
		NotificationCenter.default.addObserver(self, selector: #selector(MemeEditViewController.keyboardWillShow(_:))	, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(MemeEditViewController.keyboardWillHide(_:))	, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
	}


	//Called in viewWillDisappear.
	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name:
			NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.removeObserver(self, name:
			NSNotification.Name.UIKeyboardWillHide, object: nil)
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
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
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
