//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Daniel Riehs on 3/14/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

//import Foundation
import UIKit

class MemeTableViewController: UITableViewController
{


	//Determining the file path where the archived data is stored by the NSKeyedArchiver.
	var filePath : String {
		let manager = NSFileManager.defaultManager()
		let url = manager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first! as NSURL
		return url.URLByAppendingPathComponent("memesArray").path!
	}


	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Memes.sharedInstance().memes.count
	}


	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")
		let meme = Memes.sharedInstance().memes[indexPath.row]

		//The memed image and the top line of text display for each meme.
		cell!.imageView?.image = UIImage(data: meme.memedImage)
		cell!.textLabel?.text = meme.topText

		return cell!
	}


	override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
		return true
	}


	//Selecting a row navigates the user to a detail view of the meme.
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let storyboard = UIStoryboard (name: "Main", bundle: nil)
		let resultVC = storyboard.instantiateViewControllerWithIdentifier("memeImageDetail") as! MemeDetailViewController
		navigationController?.pushViewController(resultVC, animated: true)

		resultVC.meme = Memes.sharedInstance().memes[indexPath.row]
	}


	//Deleting a meme:
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		if editingStyle == UITableViewCellEditingStyle.Delete {

			//Remove the deleted meme from the array.
			Memes.sharedInstance().memes.removeAtIndex(indexPath.row)

			//Saving the array to the file.
			NSKeyedArchiver.archiveRootObject(Memes.sharedInstance().memes, toFile: filePath)

			//Delete the meme from the tableView.
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
	}
}
