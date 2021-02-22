
import UIKit
import IBAnimatable
import Razorpay

class CheckoutVC: UIViewController, MyPromocodeAccess {
    
    func promocodeApply(myData: CoupenList_Data) {
        self.lblPromoCode.text = myData.couponCode
        coupenCode = myData.couponCode!
        self.viewDidLayoutSubviews()
        self.viewPromoCodeHghtCnst.constant = 120
        self.lblPromoCode.isHidden = false
        
        self.lblApply.text = "Applied"
        btnCode.isUserInteractionEnabled = false
        serverHitForApplyCoupen()
        
    }
    var myloader = MyLoader()
    var razorpay: RazorpayCheckout!
    var paymentID = String()
    
    @IBOutlet var buttonQuesSessionCollection: [UIButton]!
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewHeader: AnimatableView!
    @IBOutlet weak var btnWallet: UIButton!
    @IBOutlet weak var btnCashOnDelivery: UIButton!
    @IBOutlet weak var btnCard: UIButton!
    @IBOutlet weak var btnCode: UIButton!
    @IBOutlet weak var lblLine1: UILabel!
    @IBOutlet weak var lblLine2: UILabel!
    
    @IBOutlet weak var viewWalletCircle: UIView!
    @IBOutlet weak var lblwalletCircle: UILabel!
    
    @IBOutlet weak var viewCashCircle: UIView!
    @IBOutlet weak var lblCashCircle: UILabel!
    
    @IBOutlet weak var viewCardCircle: UIView!
    @IBOutlet weak var lblCardCircle: UILabel!
    @IBOutlet weak var lblCash: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblPromoCode: UILabel!
    
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblApply: AnimatableLabel!
    @IBOutlet weak var viewPromoCodeHghtCnst: NSLayoutConstraint!
    
    var isPay = Bool()
    var coupenCode = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checboxCash()
        checboxCard()
        checboxWallet()
        serverHitForRewardLine()
        //Razorpay key
        razorpay = RazorpayCheckout.initWithKey("rzp_test_GM7HfEBCLNqtSV", andDelegate: self)
        self.viewPromoCodeHghtCnst.constant = 66
        self.lblPromoCode.isHidden = true
        self.lblTotalPrice.text = "Rs.\(tolalItemPrice)"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.lblPromoCode.text?.count == 0 { return
        }
        
         setGradientBackground(view1: self.btnCode, colorTop: #colorLiteral(red: 0.9176587462, green: 0.7964373231, blue: 0.5519171953, alpha: 1), colorBottom: #colorLiteral(red: 0.9893639684, green: 0.5103693604, blue: 0, alpha: 1))
     
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func resetAction(_ sender: Any) {
        
        btnCashOnDelivery.isSelected = false
        btnCard.isSelected = false
        btnCode.isSelected = false
        checboxCash()
        checboxCard()
        checboxWallet()
        
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender {
            
        case btnWallet:
            viewWalletCircle.layer.borderWidth = 2
            viewWalletCircle.layer.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            lblwalletCircle.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            checboxCash()
            checboxCard()
            wallet = "yes"
            let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "WalletVC") as! WalletVC
            self.navigationController?.pushViewController(viewController, animated: true)

        case btnCashOnDelivery:
            isPay = true
            checboxCard()
            checboxWallet()
            wallet = "no"
            paymentMetod = "COD"
            viewCashCircle.layer.borderWidth = 2
            viewCashCircle.layer.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            lblCashCircle.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            lblCash.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lblCard.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            setGradientBackground(view1: btnCard, colorTop: .white, colorBottom: .white)
            setGradientBackground(view1: btnCashOnDelivery, colorTop: #colorLiteral(red: 0.9176587462, green: 0.7964373231, blue: 0.5519171953, alpha: 1), colorBottom: #colorLiteral(red: 0.9893639684, green: 0.5103693604, blue: 0, alpha: 1))
        case btnCard:
            isPay = false
            checboxWallet()
            checboxCash()
            wallet = "no"
            paymentMetod = "COD"
            viewCardCircle.layer.borderWidth = 2
            viewCardCircle.layer.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            lblCardCircle.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            lblCash.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            lblCard.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            setGradientBackground(view1: btnCashOnDelivery, colorTop: .white, colorBottom: .white)
            setGradientBackground(view1: btnCard, colorTop: #colorLiteral(red: 0.9176587462, green: 0.7964373231, blue: 0.5519171953, alpha: 1), colorBottom: #colorLiteral(red: 0.9893639684, green: 0.5103693604, blue: 0, alpha: 1))
           
        case btnCode:
            let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "CoupenVC") as! CoupenVC
            viewController.isCoupen = true
            viewController.delegate = self
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            print("fsdf")
        }
    }
    
    
    
    @IBAction func payAction(_ sender: UIButton) {
        switch isPay {
        case true:
            serverHitForCheckOut()
        case false:
            showPaymentForm()
        default:
            print("dfdgg")
        }
        
    }
    
}

//MARK:- Api
extension CheckoutVC {
        // CoupenList
    func serverHitForRewardLine(){
        // email, password, Auth-key
        let dict = ["cart_id": cartID]
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "rewardlines", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(RewardLines.self, from: jsonData!)
                if obj.status == "1"{
                    self.lblLine1.text = "\(UnwarppingValue(value: obj.line1))"
                    self.lblLine2.text = "\(UnwarppingValue(value: obj.line2))"
                    
                } else{
                    // showToast(message: obj.msg ?? "something went wrong", vc: self, normalColor: false)
                }
            }
        }
    }
    
    func serverHitForApplyCoupen(){
          // email, password, Auth-key
        let dict = ["cart_id": cartID,"coupon_code":coupenCode] as [String : Any]
          WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "apply_coupon", showIndicator: false){ (responseData) in
              DispatchQueue.main.async {
                 // self.myloader.removeLoader(controller: self)
                  let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                  let decoder = JSONDecoder()
                  let obj = try! decoder.decode(ApplyCoupen.self, from: jsonData!)
                  if obj.status == "1"{
                      showToast(message: obj.message ?? "something went wrong", vc: self, normalColor: false)
                  } else {
                       showToast(message: obj.message ?? "something went wrong", vc: self, normalColor: false)
                  }
              }
          }
      }
    //CheckOut
    func serverHitForCheckOut(){
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["user_id": userID, "payment_method": paymentMetod, "cart_id": cartID, "payment_status": paymentStatus,"wallet": wallet ] as [String : Any]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "checkout", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Make_On_Order.self, from: jsonData!)
                if obj.status == "1"{
                    let storyboard = UIStoryboard.init(name: "Chekout", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "OrderSuccessfullVC") as! OrderSuccessfullVC
                    ProductDetailManager.sharedInstance.productDetails = [:]
                       self.navigationController?.pushViewController(viewController, animated: true)
                } else{
                    showToast(message: obj.message ?? "something went wrong", vc: self, normalColor: false)
                }
            }
        }
    }
      
   //MARK:- CheckBox function
    //Wallet checkbox
    func checboxWallet() {
        self.viewWalletCircle.layer.cornerRadius = 22/2
        self.viewWalletCircle.clipsToBounds = true
        self.lblwalletCircle.layer.cornerRadius = 10/2
        self.lblwalletCircle.clipsToBounds = true
        viewWalletCircle.layer.borderWidth = 2
        viewWalletCircle.layer.borderColor =  #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lblwalletCircle.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    
    //Card checkbox
    func checboxCard() {
        self.viewCardCircle.layer.cornerRadius = 22/2
        self.viewCardCircle.clipsToBounds = true
        self.lblCardCircle.layer.cornerRadius = 10/2
        self.lblCardCircle.clipsToBounds = true
        viewCardCircle.layer.borderWidth = 2
        viewCardCircle.layer.borderColor =  #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lblCardCircle.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    
    //Cash checkbox
    func checboxCash() {
        self.viewCashCircle.layer.cornerRadius = 22/2
        self.viewCashCircle.clipsToBounds = true
        self.lblCashCircle.layer.cornerRadius = 10/2
        self.lblCashCircle.clipsToBounds = true
        viewCashCircle.layer.borderWidth = 2
        viewCashCircle.layer.borderColor =  #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        lblCashCircle.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
    }
    //pay_FKliDBXRq8uGQi
}

extension CheckoutVC : RazorpayPaymentCompletionProtocol {
    
    func showPaymentForm(){
        let options: [String:Any] = [
                    "amount": "\(tolalItemPrice * 100)", //This is in currency subunits. 100 = 100 paise= INR 1.
                    "currency": "INR",//We support more that 92 international currencies.
                    "description": "purchase description",
                //  "order_id": orderID,
                    "image": "https://url-to-image.png",
                    "name": "business or product name",
                    "prefill": [
                        "contact": userphone,
                        "email": useremail
                    ],
                    "theme": [
                        "color": "#F37254"
                    ]

                ]
        razorpay.open(options)
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
        self.presentAlert(withTitle: "Alert", message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        
        paymentID = payment_id
        if paymentID != "" {
           paymentStatus = "success"
            serverHitForCheckOut()
        } else {
            paymentStatus = "failed"
        }

    }
    
}

// RazorpayPaymentCompletionProtocolWithData - This will returns you the data in both error and success case. On payment failure you will get a code and description. In payment success you will get the payment id.
extension CheckoutVC: RazorpayPaymentCompletionProtocolWithData {
    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("error: ", code)
        self.presentAlert(withTitle: "Alert", message: str)
    }

    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("success: ", payment_id)
        self.presentAlert(withTitle: "Success", message: "Payment Succeeded")
    }

    
    func presentAlert(withTitle title: String?, message : String?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Okay", style: .default)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
