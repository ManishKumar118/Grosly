//
//  ExpandTableViewCell.swift
//  GoGrocer
//
//  Created by Pooja on 01/06/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

class ExpandTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var viewBottomCnst: NSLayoutConstraint!
    @IBOutlet weak var viewMain: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
