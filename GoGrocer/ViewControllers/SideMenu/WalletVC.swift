//
//  WalletVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import Alamofire

class WalletVC: UIViewController {

    var myloader = MyLoader()
    var register = [Register_DataClass]()

    @IBOutlet weak var lblValue: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()
        serverHitForWalletAmount()
            // Do any additional setup after loading the view.
        }
    
       @IBAction func backAction(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
           

        @IBAction func redeemAction(_ sender: Any) {
             let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
             let viewController = storyboard.instantiateViewController(withIdentifier: "WalletRechargeVC") as! WalletRechargeVC
             self.navigationController?.pushViewController(viewController, animated: true)
        }
    
    
    func serverHitForWalletAmount(){
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["user_id": 3]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "walletamount", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(WalletAmount.self, from: jsonData!)
                if obj.status == "1"{
                    self.lblValue.text = "\(UnwarppingValue(value: obj.data))"
                } else{
                    // showToast(message: obj.msg ?? "something went wrong", vc: self, normalColor: false)
                }
            }
        }
    }
    
    }
