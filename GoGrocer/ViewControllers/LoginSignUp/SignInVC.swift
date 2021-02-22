//
//  SignInVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable
import Alamofire

class SignInVC: UIViewController {
    
    @IBOutlet weak var txtFieldUserID: AnimatableTextField!
    @IBOutlet weak var txtFieldPassword: AnimatableTextField!
    var myloader = MyLoader()
    var register = [Register_DataClass]()
    var registeredData: Register_DataClass?
    var maxLen:Int = 10;
    
    @IBAction func btnSkipTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //  txtFieldPassword.delegate = self
        // txtFieldUserID.text = "8699007019"
        //  txtFieldPassword.text = "qwertyuiop"
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signInAction(_ sender: Any) {
        if txtFieldUserID.text!.isEmpty {
            showToast(message: Message.BlankMobileNumberMsg, vc: self, normalColor: false)
        } else if txtFieldPassword.text!.isEmpty {
            showToast(message: Message.BlankPasswordMsg, vc: self, normalColor: false)
        } else {
            serverHitForLogin()
        }
    }
    
    @IBAction func ForgotPasswrdAction(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func signUPAction(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func serverHitForLogin(){
        
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        
        if UserDefaults.standard.value(forKey: "DeviceToken") == nil {
            UserDefaults.standard.setValue("123456", forKey: "DeviceToken")
        }
        
        let dict = ["user_password":txtFieldPassword.text!,"user_phone":txtFieldUserID.text!,"device_id":UserDefaults.standard.value(forKey: "DeviceToken") as! String]
        print(dict)
        print("heheheheheheheh")
        WebServices().requestWithPost(baseUrl: baseUrlTest, endUrl: "login", parameters: dict, onCompletion: { (responseData) in
            print(responseData)
            let status = responseData["status"] as? String
            if status == "1" { //if status == "1" {
                do {
                    let decoder = JSONDecoder()
                    self.register = try decoder.decode([Register_DataClass].self, from: JSONSerialization.data(withJSONObject: responseData["data"] as! [[String:Any]], options: []))
                    print(self.register)
                    print(self.register)
                    for item in self.register {
                        if let userID = item.userID {
                            print("here is user id user id",userID)
                            saveStringInDefault(value: userID, key: "userID")
                        }else{
                            saveStringInDefault(value: "", key: "userID")
                        }
                        
                        if let userName = item.userName {
                            saveStringInDefault(value: userName, key: "userName")
                        } else {
                            saveStringInDefault(value: "", key: "userName")
                        }
                        
                        if let userEmail = item.userEmail {
                            saveStringInDefault(value: userEmail, key: "userEmail")
                        } else {
                            saveStringInDefault(value: "", key: "userEmail")
                        }
                        
                        if let userPhone = item.userPhone {
                            saveStringInDefault(value: userPhone, key: "userPhone")
                        } else {
                            saveStringInDefault(value: "", key: "userPhone")
                        }
                        
                        UserDefaults.standard.setValue(true, forKey: "activateLogin")
                    }
                    
                    let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                    self.navigationController?.pushViewController(viewController, animated: true)
                    
                } catch let err {
                    self.myloader.removeLoader(controller: self)
                    print(err)
                }
                
            } else {
                self.myloader.removeLoader(controller: self)
                //     alert(message: responseData["message"] as? String ?? "Something went wrong", title: "")
                showToast(message: responseData["message"] as? String ?? "Something went wrong", vc: self, normalColor: true)
            }
        }) { (error) in
            print(error!)
        }
        
    }
    
}
// MARK: - TextField Delegate
extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == txtFieldUserID){
            let currentText = textField.text! + string
            return currentText.count <= maxLen
        }
        
        return true;
    }
}
