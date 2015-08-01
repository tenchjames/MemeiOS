//
//  Meme.swift
//  Meme
//
//  Created by James Tench on 7/31/15.
//  Copyright (c) 2015 James Tench. All rights reserved.
//  Model Class to hold a meme
//

import Foundation
import UIKit

class Meme {
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
}
