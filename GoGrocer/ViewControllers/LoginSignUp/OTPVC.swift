//
//  OTPVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable

class OTPVC: UIViewController {
    
    @IBOutlet weak var txtFieldNumber: AnimatableTextField!
    @IBOutlet weak var txtfieldOtp: AnimatableTextField!
    var myloader = MyLoader()
    var phone = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFieldNumber.text = phone
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func verifyAction(_ sender: Any) {
        serverHitForLogin()
    }
    
    @IBAction func EditVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func serverHitForLogin(){
        
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["otp":txtfieldOtp.text!,"user_phone":txtFieldNumber.text!]
        
        //        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        //verify_phone
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "verify_otp", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(OTP.self, from: jsonData!)
                if obj.status == 1 {
                    let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                } else {
                    showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
                }
            }
        }
    }
    
    
}

