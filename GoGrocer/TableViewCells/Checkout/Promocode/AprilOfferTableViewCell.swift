//
//  AprilOfferTableViewCell.swift
//  GoGrocer
//
//  Created by Pooja on 03/07/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

class AprilOfferTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOfferName: UILabel!
    @IBOutlet weak var lblOfferDescription: UILabel!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnApply: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
