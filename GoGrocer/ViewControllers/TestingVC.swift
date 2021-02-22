//
//  TestingVC.swift
//  GoGrocer
//
//  Created by Pooja on 15/07/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

class TestingVC: UIViewController {

    @IBOutlet weak var hghtCnst: NSLayoutConstraint!
    
    @IBOutlet weak var lbl2: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl2.isHidden = true
        hghtCnst.constant = 60
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnAction(_ sender: Any) {
        lbl2.isHidden = false
        hghtCnst.constant = 100
    }
    

}
