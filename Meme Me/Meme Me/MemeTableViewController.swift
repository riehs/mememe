//
//  MemeTableViewController.swift
//  Meme Me
//
//  Created by Daniel Riehs on 3/14/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UITableViewController
{


	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Memes.sharedInstance().memes.count
	}


	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("memeCell")
		let meme = Memes.sharedInstance().memes[indexPath.row]
		
		//The memed image and the top line of text display for each meme.
		cell!.imageView?.image = meme.memedImage
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

			//Remove the deleted meme from the Core Data context.
			CoreDataStackManager.sharedInstance().managedObjectContext.deleteObject(Memes.sharedInstance().memes[indexPath.row] as NSManagedObject)

			//Remove the deleted meme from the array.
			Memes.sharedInstance().memes.removeAtIndex(indexPath.row)

			//Save the Core Data context.
			CoreDataStackManager.sharedInstance().saveContext()

			//Delete the meme from the tableView.
			tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
		}
	}
}
