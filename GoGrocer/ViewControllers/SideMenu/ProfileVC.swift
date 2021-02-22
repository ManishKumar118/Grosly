//
//  ProfileVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable

class ProfileVC: UIViewController {
    
    @IBOutlet weak var txtFieldEmail: AnimatableTextField!
    @IBOutlet weak var txtFieldMobile: AnimatableTextField!
    @IBOutlet weak var txtFieldName: AnimatableTextField!
    @IBOutlet weak var switchEmail: PVSwitch!
    @IBOutlet weak var switchSMS: PVSwitch!
    @IBOutlet weak var switchInApp: PVSwitch!
    
    var myloader = MyLoader()
    var emailSwitch = Int()
    var smsSwitch = Int()
    var appSwitch = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()
  //      btnEmail.transform = CGAffineTransform(scaleX: 0.75, y: 0.70)
        serverHitProfile()
        serverHitSmsEmailApp()
        switchEmail.addTarget(self, action: #selector(ProfileVC.emailSwitchAction(sender:)), for: .valueChanged)
        switchSMS.addTarget(self, action: #selector(ProfileVC.smsSwitchAction(sender:)), for: .valueChanged)
        switchInApp.addTarget(self, action: #selector(ProfileVC.inAppSwitchAction(sender:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func SaveAction(_ sender: Any) {
      serverHitupdateSmsEmailApp()
    }
    
    @IBAction func continueAction(_ sender: Any) {
      serverHitForUpdateProfile()
    }
    
       
    @objc func emailSwitchAction(sender :PVSwitch) {
        if(sender.isOn == true) {
            self.emailSwitch = 1
           }else{
            self.emailSwitch = 0
        }
    }
    
    @objc func smsSwitchAction(sender :PVSwitch) {
        if(sender.isOn == true) {
            self.smsSwitch = 1
           }else{
            self.smsSwitch = 0
        }
    }
    
    @objc func inAppSwitchAction(sender :PVSwitch) {
        if(sender.isOn == true) {
            self.appSwitch = 1
           }else{
            self.appSwitch = 0
        }
    }
    
}

//MARK:- APi Call
extension ProfileVC {
   // get detail
  func serverHitProfile(){
        
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["user_id": fetchString(key: "userID")]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "myprofile", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Register.self, from: jsonData!)
                if obj.status == "1" {
                    self.txtFieldName.text = "\(UnwarppingValue(value: obj.data?.userName))"
                    self.txtFieldEmail.text = "\(UnwarppingValue(value: obj.data?.userEmail))"
                    self.txtFieldMobile.text = "\(UnwarppingValue(value: obj.data?.userPhone))"
                
                } else {
                    showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
                }
            }
        }
    }
    
    // get email, sms, app
    func serverHitSmsEmailApp(){
        // email, password, Auth-key
        let dict = ["user_id": fetchString(key: "userID")]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "notifyby", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Profile.self, from: jsonData!)
                if obj.status == "1" {
                    if obj.data?.sms == 1{
                        self.switchSMS.isOn = true
                    } else {
                        self.switchSMS.isOn = false
                    }
                    if obj.data?.app == 1{
                        self.switchInApp.isOn = true
                    } else {
                        self.switchInApp.isOn = false
                    }
                    if obj.data?.email == 1{
                        self.switchEmail.isOn = true
                    } else {
                        self.switchEmail.isOn = false
                    }
                } else {
                    showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
                }
            }
        }
    }
    
    func serverHitupdateSmsEmailApp(){
           // email, password, Auth-key
        let dict = ["user_id": fetchString(key: "userID"), "sms" : smsSwitch, "app" : appSwitch, "email" : emailSwitch] as [String : Any]
           WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "updatenotifyby", showIndicator: false){ (responseData) in
               DispatchQueue.main.async {
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                   let decoder = JSONDecoder()
                   let obj = try! decoder.decode(UpdateProfile.self, from: jsonData!)
                   if obj.status == "1" {
                    showToastAlert(message: obj.message! , vc: self, normalColor: true)
                    print("fsfr")
                   } else {
                    showToastAlert(message: obj.message! , vc: self, normalColor: true)
                   }
               }
           }
       }
    
    func serverHitForUpdateProfile() {
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["user_email":txtFieldEmail.text!,"user_name": txtFieldName.text!,"user_phone":txtFieldMobile.text!,"user_id": fetchString(key: "userID") ] as [String : Any]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "profile_edit", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Register.self, from: jsonData!)
                if obj.status == "1" {
                    showToastAlert(message: obj.message! , vc: self, normalColor: true)
                } else {
                    showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
                }
            }
        }
    }
}
