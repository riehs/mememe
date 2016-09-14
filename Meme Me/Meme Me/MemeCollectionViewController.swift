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


	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return Memes.sharedInstance().memes.count
	}


	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell", for: indexPath) 
		let meme = Memes.sharedInstance().memes[(indexPath as NSIndexPath).item]


		//A memed image displays in each cell.
		cell.backgroundView = UIImageView(image: UIImage(data: meme.memedImage as Data))

		return cell
	}


	//Selecting an item navigates the user to a detail view of the meme.
	override func collectionView(_ tableView: UICollectionView, didSelectItemAt indexPath: IndexPath)
	{
		let storyboard = UIStoryboard (name: "Main", bundle: nil)
		let resultVC = storyboard.instantiateViewController(withIdentifier: "memeImageDetail") as! MemeDetailViewController
		navigationController?.pushViewController(resultVC, animated: true)

		resultVC.meme = Memes.sharedInstance().memes[(indexPath as NSIndexPath).row]
	}
}
