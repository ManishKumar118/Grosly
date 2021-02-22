//
//  NotificarionTableViewCell.swift
//  GoGrocer
//
//  Created by Pooja on 25/06/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

class NotificarionTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
