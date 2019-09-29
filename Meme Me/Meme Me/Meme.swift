//
//  Meme.swift
//  Meme Me
//
//  Created by Daniel Riehs on 3/14/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import UIKit
import Foundation

class Meme: NSCoder {

	let topText: String
	let bottomText: String
	let image: Data
	let memedImage: Data

	init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {

		self.topText = topText
		self.bottomText = bottomText

		//The '1' means that the images are stored at the highest quality.
		self.image = image.jpegData(compressionQuality: 1)!
		self.memedImage = memedImage.jpegData(compressionQuality: 1)!
	}


	//Required for the class to conform to the NSCoding protocol.
	@objc func encodeWithCoder(_ aCoder: NSCoder!) {
		aCoder.encode(topText, forKey:"topText")
		aCoder.encode(bottomText, forKey:"bottomText")
		aCoder.encode(image, forKey:"image")
		aCoder.encode(memedImage, forKey:"memedImage")
	}


	//Required for the class to conform to the NSCoding protocol.
	@objc init(coder aDecoder: NSCoder!) {
		topText = aDecoder.decodeObject(forKey: "topText") as! String
		bottomText = aDecoder.decodeObject(forKey: "bottomText") as! String
		image = aDecoder.decodeObject(forKey: "image") as! Data
		memedImage = aDecoder.decodeObject(forKey: "memedImage") as! Data
	}
}
