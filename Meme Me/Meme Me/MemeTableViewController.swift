//
//  MemeTableViewController.swift
//  Pick and Image
//
//  Created by Daniel Riehs on 3/14/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

//import Foundation
import UIKit

class MemeTableViewController: UITableViewController
{
    var memes: [Meme]!
    
    override func viewDidLoad() {

        // The shared model is stored in the AppDelegate class.
        let applicationDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        memes = applicationDelegate.memes
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memeCell") as UITableViewCell
        let meme = self.memes[indexPath.row]
        
        //The memed image and the top line of text display for each meme.
        cell.imageView?.image = meme.memedImage
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
        
        resultVC.meme = self.memes[indexPath.row]
    }
}
