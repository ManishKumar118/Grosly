//
//  UpdatePassword.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable

class UpdatePassword: UIViewController {
    
    @IBOutlet weak var txtFielUpdatePass: AnimatableTextField!
    
    var myloader = MyLoader()
    var register = [Register_DataClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func serverHitForLogin(){
        
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["user_password":txtFielUpdatePass.text!,"user_phone":"user_phone"]
        
        WebServices().requestWithPost(baseUrl: baseUrlTest, endUrl: "change_password", parameters: dict, onCompletion: { (responseData) in
            print(responseData)
            let status = responseData["status"] as? String
            if status == "1" {
                do {
                    let decoder = JSONDecoder()
                    self.register = try decoder.decode([Register_DataClass].self, from: JSONSerialization.data(withJSONObject: responseData["data"] as! [[String:Any]], options: []))
                    print(self.register)
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                    self.navigationController?.pushViewController(viewController, animated: true)
                } catch let err {
                    self.myloader.removeLoader(controller: self)
                    print(err)
                }
                
            } else {
                self.myloader.removeLoader(controller: self)
                showToastAlert(message: responseData["message"] as? String ?? "Something went wrong", vc: self, normalColor: true)
            }
        }) { (error) in
            print(error!)
        }
    }
    
}
