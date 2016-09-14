//
//  Memes.swift
//  Meme Me
//
//  Created by Daniel Riehs on 3/23/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import Foundation

class Memes: NSCoder {

	var memes : [Meme] = [Meme]()

	override init() {}

	//Allows other classes to reference a common instance of the memes array.
	class func sharedInstance() -> Memes {

		struct Singleton {
			static var sharedInstance = Memes()
		}
		return Singleton.sharedInstance
	}


	//Required for the class to conform to the NSCoding protocol.
	required init(coder aDecoder: NSCoder) {
		if let memes = aDecoder.decodeObject(forKey: "memesArray") as? [Meme] {
			self.memes = memes
		}
	}


	//Required for the class to conform to the NSCoding protocol.
	func encodeWithCoder(_ aCoder: NSCoder) {
		aCoder.encode(self.memes, forKey: "memesArray")
	}
}
