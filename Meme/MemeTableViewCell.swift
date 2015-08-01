//
//  MemeTableViewCell.swift
//  Meme
//
//  Created by James Tench on 7/31/15.
//  Copyright (c) 2015 James Tench. All rights reserved.
//  Custom TableView cell for memes
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
