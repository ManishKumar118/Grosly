//
//  QuantityTableViewCell.swift
//  Animake
//
//  Created by Pooja on 01/06/20.
//  Copyright © 2020 Ankur Purwar. All rights reserved.
//

import UIKit
import IBAnimatable

class QuantityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblKg: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblMrp: UILabel!
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var lblNumberItem: UILabel!
    @IBOutlet weak var btnIncreese: AnimatableButton!
    @IBOutlet weak var btnMin: AnimatableButton!
    @IBOutlet weak var btnAdd: AnimatableButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var viewAddCart: AnimatableView!
   
    var lblNumberofItem = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
