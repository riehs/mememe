//
//  MemeCollectionViewController.swift
//  Pick and Image
//
//  Created by Daniel Riehs on 3/14/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController
{
    var memes: [Meme]!
    
    override func viewDidLoad() {

        let applicationDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        memes = applicationDelegate.memes
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as UICollectionViewCell
        let meme = memes[indexPath.item]
        
        
        //A memed image displays in each cell.
        cell.backgroundView = UIImageView(image: meme.memedImage)
        
        return cell
    }

    
    //Selecting an item navigates the user to a detail view of the meme.
    override func collectionView(tableView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var resultVC = storyboard.instantiateViewControllerWithIdentifier("memeImageDetail") as MemeDetailViewController
        self.navigationController?.pushViewController(resultVC, animated: true)

        resultVC.meme = self.memes[indexPath.row]
    }

}