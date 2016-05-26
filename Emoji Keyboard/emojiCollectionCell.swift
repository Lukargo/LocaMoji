//
//  emojiCollectionCell.swift
//  Emoji Keyboard
//
//  Created by Luke Stevens on 5/25/16.
//  Copyright © 2016 OnMilwaukee. All rights reserved.
//

import UIKit

class emojiCollectionCell: UICollectionViewCell {
    
    @IBOutlet var emojiIMage: UIImageView!
    @IBOutlet var emojiNameLabel: UILabel!
    @IBOutlet var payWall: UIView!
    @IBOutlet var buyButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}