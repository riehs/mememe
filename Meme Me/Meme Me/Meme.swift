//
//  Meme.swift
//  Meme Me
//
//  Created by Daniel Riehs on 3/14/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import UIKit
import CoreData

//Make Meme available to Objective-C code. (Necessary for Core Data.)
@objc(Meme)

//Make Meme a subclass of NSManagedObject. (Necessary for Core Data.)
class Meme: NSManagedObject {

    
    //Promoting these four properties to Core Data attributes by prefixing them with @NSManaged.
    @NSManaged var topText: String
    @NSManaged var bottomText: String
    @NSManaged var image: UIImage
    @NSManaged var memedImage: UIImage
    
    
    //The UIImages are stored in Core Data as type "Transformable".
    //They can also be stored as type "Binary Data" if they are first converted to NSData objects.
    //
    //Code to create an NSData object by passing in a UIImage:
    //dataImage = UIImageJPEGRepresentation(image, 1)
    //
    //Code to create a UIImage by passing in an NSData object:
    //image = UIImage(data: dataImage)
    

    //The standard Core Data init method.
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    

    //The init method needs to accept the shared context as one of its parameters.
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage, context: NSManagedObjectContext) {
        
        //The entity name here is the same as the entity name in the Model.xcdatamodeld file.
        let entity =  NSEntityDescription.entityForName("Meme", inManagedObjectContext: context)!

        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.topText = topText
        self.bottomText = bottomText
        
        self.image = image
        self.memedImage = memedImage
    }
    
}
