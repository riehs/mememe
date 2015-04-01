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

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Memes.sharedInstance().memes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as UITableViewCell
        let meme = Memes.sharedInstance().memes[indexPath.row]
        
        //The memed image and the top line of text display for each meme.
        //The memed image must be converted into a UIImage, because it is stored in the meme object as NSData. (This is necessary to store the image in Core Data.)
        cell.imageView?.image = UIImage(data: meme.memedImage)
        cell.textLabel?.text = meme.topText
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //Selecting a row navigates the user to a detail view of the meme.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var resultVC = storyboard.instantiateViewControllerWithIdentifier("memeImageDetail") as MemeDetailViewController
        self.navigationController?.pushViewController(resultVC, animated: true)
        
        resultVC.meme = Memes.sharedInstance().memes[indexPath.row]
    }
}
