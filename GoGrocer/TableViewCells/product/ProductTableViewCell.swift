//
//  ProductTableViewCell.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblProduct: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lbloffer: UILabel!

    @IBOutlet weak var lblKg: UILabel!
    @IBOutlet weak var lblNumberItem: UILabel!
    @IBOutlet weak var btnIncreese: AnimatableButton!
    @IBOutlet weak var btnMin: AnimatableButton!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblOfferPrice: UILabel!
    @IBOutlet weak var btnAdd: AnimatableButton!
    @IBOutlet weak var viewAddCart: AnimatableView!
    @IBOutlet weak var viewAdd: UIView!
    
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
