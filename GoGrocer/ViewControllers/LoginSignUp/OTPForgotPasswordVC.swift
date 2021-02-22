//
//  OTPForgotPasswordVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable

class OTPForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var txtFieldOtp: AnimatableTextField!
    
    var phone = ""
    var myloader = MyLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        self.lblNumber.text = phone
        // Do any additional setup after loading the view.
    }
    
    @IBAction func veryfyAction(_ sender: Any) {
        self.serverHitForLogin()
    }
    
    func serverHitForLogin(){
        
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["otp":txtFieldOtp.text!,"user_phone":lblNumber.text!]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "verify_otp", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(OTP.self, from: jsonData!)
                if obj.status == 1 {
                    let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdatePassword") as? UpdatePassword
                    self.navigationController?.pushViewController(obj!, animated: true)
                    
                } else {
                    showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
                }
            }
        }
    }
    
    
}
