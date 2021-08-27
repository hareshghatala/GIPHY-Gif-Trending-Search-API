//
//  GIFFeedTableViewCell.swift
//  Giphy GIFs
//
//  Created by Haresh Ghatala on 2021/08/24.
//  Copyright © 2021 Haresh Ghatala. All rights reserved.
//

import UIKit

public protocol GIFFeedTableViewCellDelegate: class {
    func favouriteButtonTap(index: Int, isSelected: Bool)
}

class GIFFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!
    
    public weak var delegate: GIFFeedTableViewCellDelegate?
    public var index: Int = 0
    
    override func prepareForReuse() {
        favouriteButton.isSelected = false
        gifImageView.layer.cornerRadius = 10
        gifImageView.image = UIImage()
        index = 0
    }
    
    @IBAction func favouriteTapAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.favouriteButtonTap(index: index, isSelected: sender.isSelected)
    }
    
}
