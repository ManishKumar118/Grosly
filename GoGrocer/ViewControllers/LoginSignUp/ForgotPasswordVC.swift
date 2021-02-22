

import UIKit
import IBAnimatable

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var txtFieldMobile: AnimatableTextField!
    
    var myloader = MyLoader()
    var register = [Register_DataClass]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func verifyAction(_ sender: Any) {
        serverHitForLogin()
    }
    
    func serverHitForLogin(){
        
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["user_phone":txtFieldMobile.text!]
        
        WebServices().requestWithPost(baseUrl: baseUrlTest, endUrl: "forget_password", parameters: dict, onCompletion: { (responseData) in
            print(responseData)
            let status = responseData["status"] as? String
            if status == "1" {
                do {
                    let decoder = JSONDecoder()
                    self.register = try decoder.decode([Register_DataClass].self, from: JSONSerialization.data(withJSONObject: responseData["data"] as! [[String:Any]], options: []))
                    print(self.register)
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "OTPForgotPasswordVC") as! OTPForgotPasswordVC
                    viewController.phone = self.txtFieldMobile.text!
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

