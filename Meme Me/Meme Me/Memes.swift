//
//  Memes.swift
//  Meme Me
//
//  Created by Daniel Riehs on 3/23/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

class Memes {
    
    var memes : [Meme] = [Meme]()

    //Allows other classes to reference a common instance of the memes array.
    class func sharedInstance() -> Memes {
        
        struct Singleton {
            static var sharedInstance = Memes()
        }
        return Singleton.sharedInstance
    }
    
}
