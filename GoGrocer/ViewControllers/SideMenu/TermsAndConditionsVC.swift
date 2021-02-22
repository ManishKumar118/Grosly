//
//  TermsAndConditionsVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

class TermsAndConditionsVC: UIViewController {
     @IBOutlet weak var lblContent: UILabel!
        var myloader = MyLoader()

        override func viewDidLoad() {
            super.viewDidLoad()
            serverHitForGettingBusineeDetails()
            // Do any additional setup after loading the view.
        }
        
        @IBAction func backAction(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    
    func serverHitForGettingBusineeDetails(){
                  myloader.showLoader(controller: self)

               WebServices().hitAPiTogetDetails(serviceType : baseUrlTest + "appterms"){ (responseData) in
                   self.myloader.removeLoader(controller: self)
                    print(responseData!)
                   let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                   let decoder = JSONDecoder()
                   let obj = try! decoder.decode(AboutUS.self, from: jsonData!)
                   if obj.status == "1"{
                           self.lblContent.text = UnwarppingValue(value: obj.data?.dataDescription)
                   } else{
                                 // showToast(message: obj.msg ?? "something went wrong", vc: self, normalColor: false)
                              }
               }
           }
        
    }
