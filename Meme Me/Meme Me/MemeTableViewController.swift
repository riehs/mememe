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
		let manager = FileManager.default
		let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
		return url.appendingPathComponent("memesArray").path
	}


	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Memes.sharedInstance().memes.count
	}


	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = tableView.dequeueReusableCell(withIdentifier: "memeCell")
		let meme = Memes.sharedInstance().memes[(indexPath as NSIndexPath).row]

		//The memed image and the top line of text display for each meme.
		cell!.imageView?.image = UIImage(data: meme.memedImage as Data)
		cell!.textLabel?.text = meme.topText

		return cell!
	}


	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}


	//Selecting a row navigates the user to a detail view of the meme.
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard (name: "Main", bundle: nil)
		let resultVC = storyboard.instantiateViewController(withIdentifier: "memeImageDetail") as! MemeDetailViewController
		navigationController?.pushViewController(resultVC, animated: true)

		resultVC.meme = Memes.sharedInstance().memes[(indexPath as NSIndexPath).row]
	}


	//Deleting a meme:
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCellEditingStyle.delete {

			//Remove the deleted meme from the array.
			Memes.sharedInstance().memes.remove(at: (indexPath as NSIndexPath).row)

			//Saving the array to the file.
			NSKeyedArchiver.archiveRootObject(Memes.sharedInstance().memes, toFile: filePath)

			//Delete the meme from the tableView.
			tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
		}
	}
}
