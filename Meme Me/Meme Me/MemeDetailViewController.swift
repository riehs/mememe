//
//  MemeDetailViewController.swift
//  Meme Me
//
//  Created by Daniel Riehs on 3/14/15.
//  Copyright (c) 2015 Daniel Riehs. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController
{
	var meme: Meme!

	@IBOutlet weak var memedImage: UIImageView!

	override func viewWillAppear(_ animated: Bool) {
		memedImage.image = meme.memedImage
	}
}
