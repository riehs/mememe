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
	let image: NSData
	let memedImage: NSData

	init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {

		self.topText = topText
		self.bottomText = bottomText

		//The '1' means that the images are stored at the highest quality.
		self.image = UIImageJPEGRepresentation(image, 1)!
		self.memedImage = UIImageJPEGRepresentation(memedImage, 1)!
	}


	//Required for the class to conform to the NSCoding protocol.
	func encodeWithCoder(aCoder: NSCoder!) {
		aCoder.encodeObject(topText, forKey:"topText")
		aCoder.encodeObject(bottomText, forKey:"bottomText")
		aCoder.encodeObject(image, forKey:"image")
		aCoder.encodeObject(memedImage, forKey:"memedImage")
	}


	//Required for the class to conform to the NSCoding protocol.
	init(coder aDecoder: NSCoder!) {
		topText = aDecoder.decodeObjectForKey("topText") as! String
		bottomText = aDecoder.decodeObjectForKey("bottomText") as! String
		image = aDecoder.decodeObjectForKey("image") as! NSData
		memedImage = aDecoder.decodeObjectForKey("memedImage") as! NSData
	}
}
