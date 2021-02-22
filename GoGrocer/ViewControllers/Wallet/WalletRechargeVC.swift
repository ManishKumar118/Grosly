//
//  WalletRechargeVC.swift
//  GoGrocer
//
//  Created by Pooja on 18/06/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable
import Razorpay

class WalletRechargeVC: UIViewController, RazorpayPaymentCompletionProtocol {
    
    var razorpay: RazorpayCheckout!

    @IBOutlet weak var txtFieldAmount: AnimatableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        razorpay = RazorpayCheckout.initWithKey("rzp_test_GM7HfEBCLNqtSV", andDelegate: self)

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func rechargeAction(_ sender: Any) {
       showPaymentForm()
    }
    
     func showPaymentForm(){
        let options: [String:Any] = [
                    "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
                    "currency": "INR",//We support more that 92 international currencies.
                    "description": "purchase description",
              //      "order_id": "order_4xbQrmEoA5WJ0G",
                    "image": "https://url-to-image.png",
                    "name": "business or product name",
                    "prefill": [
                        "contact": "8707687554",
                        "email": "astha.gupta957@gmail.com"
                    ],
                    "theme": [
                        "color": "#F37254"
                    ]
                ]
        razorpay.open(options)
    }
    
    func onPaymentError(_ code: Int32, description str: String) {
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
         let alertController = UIAlertController(title: "SUCCESS", message: payment_id, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

}
