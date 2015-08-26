//
//  MemeCollectionViewController.swift
//  Meme Me
//
//  Created by Daniel Riehs on 3/14/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController
{


	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Memes.sharedInstance().memes.count
	}


	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! UICollectionViewCell
		let meme = Memes.sharedInstance().memes[indexPath.item]


		//A memed image displays in each cell.
		cell.backgroundView = UIImageView(image: meme.memedImage)

		return cell
	}


	//Selecting an item navigates the user to a detail view of the meme.
	override func collectionView(tableView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
	{
		var storyboard = UIStoryboard (name: "Main", bundle: nil)
		var resultVC = storyboard.instantiateViewControllerWithIdentifier("memeImageDetail") as! MemeDetailViewController
		self.navigationController?.pushViewController(resultVC, animated: true)

		resultVC.meme = Memes.sharedInstance().memes[indexPath.row]
	}
}
