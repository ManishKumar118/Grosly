//
//  AddressListTableViewCell.swift
//  GoGrocer
//
//  Created by Pooja on 01/07/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

class AddressListTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCircle: UIView!
    @IBOutlet weak var lblCircle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress1: UILabel!
    @IBOutlet weak var lblAddress2: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnCheckBox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewCircle.layer.cornerRadius = 22/2
        self.viewCircle.clipsToBounds = true
        self.lblCircle.layer.cornerRadius = 10/2
        self.lblCircle.clipsToBounds = true
        viewCircle.layer.borderWidth = 2
        viewCircle.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lblCircle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
