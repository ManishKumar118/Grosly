//
//  RewardVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

class RewardVC: UIViewController {
    var myloader = MyLoader()
    @IBOutlet weak var lblLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serverHitForGettingBusineeDetails()

        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func redeemAction(_ sender: Any) {
        serverHitForGettingBusineeDetails()
    }
    
    func serverHitForGettingBusineeDetails(){
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["user_id": fetchString(key: "userID") ]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "myprofile", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Register.self, from: jsonData!)
                if obj.status == "1"{
                    self.lblLabel.text = "\(UnwarppingValue(value: obj.data?.rewards))"
                } else{
                    // showToast(message: obj.msg ?? "something went wrong", vc: self, normalColor: false)
                }
            }
        }
    }
    
}
