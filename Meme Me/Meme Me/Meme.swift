//
//  Meme.swift
//  Pick and Image
//
//  Created by Daniel Riehs on 3/14/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    
    let topText: String
    let bottomText: String
    let image: UIImage
    let memedImage: UIImage
    
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage)
    {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
