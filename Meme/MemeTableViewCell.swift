//
//  MemeTableViewCell.swift
//  Meme
//
//  Created by James Tench on 7/31/15.
//  Copyright (c) 2015 James Tench. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
