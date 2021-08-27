//
//  FavouriteCollectionViewCell.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/24.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import UIKit
import JellyGif

public protocol FavouriteCollectionViewCellDelegate: class {
    func unfavouriteButtonTap(index: Int)
}

class FavouriteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gifImageView: JellyGifImageView!
    @IBOutlet weak var unfavouriteButton: UIButton!
    
    public weak var delegate: FavouriteCollectionViewCellDelegate?
    public var index: Int = 0
    
    override func prepareForReuse() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 10
        unfavouriteButton.isSelected = true
        gifImageView.image = UIImage()
        index = 0
    }
    
    @IBAction func unfavouriteTapAction(_ sender: UIButton) {
        delegate?.unfavouriteButtonTap(index: index)
    }
}
