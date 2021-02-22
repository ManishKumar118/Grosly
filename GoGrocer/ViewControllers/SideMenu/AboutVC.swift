//
//  AboutVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var lblContent: UILabel!
    
    var myloader = MyLoader()
    var about: [About_us_Data]?
    
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

            WebServices().hitAPiTogetDetails(serviceType : baseUrlTest + "appaboutus"){ (responseData) in
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
