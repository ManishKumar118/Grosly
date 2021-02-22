import UIKit
import IBAnimatable
import Alamofire

class SignUpVC: UIViewController {
    
    @IBOutlet weak var txtFieldUserName: AnimatableTextField!
    @IBOutlet weak var txtFieldMobile: AnimatableTextField!
    @IBOutlet weak var txtFieldEmail: AnimatableTextField!
    @IBOutlet weak var txtFieldPassword: AnimatableTextField!
    
    var myloader = MyLoader()
    var register = [Register_DataClass]()
    var maxLen:Int = 10;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SignUpAction(_ sender: Any) {
        serverHitForLogin()
    }
    
    @IBAction func logInAction(_ sender: Any) {
        let obj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    
    func serverHitForLogin() {
        
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        if UserDefaults.standard.value(forKey: "DeviceToken") == nil {
            UserDefaults.standard.setValue("123456", forKey: "DeviceToken")
        }

        let dict = ["user_email":txtFieldEmail.text!,"user_password":txtFieldPassword.text!,"user_name": txtFieldUserName.text!,"user_phone":txtFieldMobile.text!,"device_id" : UserDefaults.standard.value(forKey: "DeviceToken") as! String]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "ios_register", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Register.self, from: jsonData!)
                if obj.status == "1" { // if obj.status == "1"
                    //Replace In to
                    /*
                    let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
                    self.navigationController?.pushViewController(viewController, animated: true)
                     */

                    if let userID = obj.data?.userID {
                        saveStringInDefault(value: userID, key: "userID")
                    } else {
                        saveStringInDefault(value: "", key: "userID")
                    }
                    
                    if let userName = obj.data?.userName {
                        saveStringInDefault(value: userName, key: "userName")
                    } else {
                        saveStringInDefault(value: "", key: "userName")
                    }
                    
                    if let userEmail = obj.data?.userEmail {
                        saveStringInDefault(value: userEmail, key: "userEmail")
                    } else {
                        saveStringInDefault(value: "", key: "userEmail")
                    }
                    
                    if let userPhone = obj.data?.userPhone {
                        saveStringInDefault(value: userPhone, key: "userPhone")
                    } else {
                        saveStringInDefault(value: "", key: "userPhone")
                    }
                    
                     UserDefaults.standard.setValue(true, forKey: "activateLogin")
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPVC") as? OTPVC
                    vc?.phone = self.txtFieldMobile.text!
                    self.navigationController?.pushViewController(vc!, animated: true)

                } else {
                    showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
                }
            }
        }
    }
    
    
    
}

//MARK: - UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.canBeConverted(to: String.Encoding.ascii){
            return false
        }
        
        if(textField == txtFieldMobile){
            let currentText = textField.text! + string
            return currentText.count <= maxLen
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
