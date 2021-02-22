//
//  ProductViewEmptyVC.swift
//  GoGrocer
//
//  Created by apple on 07/02/21.
//  Copyright © 2021 Komal Gupta. All rights reserved.
//

import UIKit

class ProductViewEmptyVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }


}
