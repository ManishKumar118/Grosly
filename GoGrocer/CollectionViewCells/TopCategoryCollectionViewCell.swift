//
//  TopCategoryCollectionViewCell.swift
//  GoGrocer
//
//  Created by Pooja on 14/06/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable

class TopCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewMain: AnimatableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
