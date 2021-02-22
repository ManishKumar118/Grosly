//
//  NotificationVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    var myloader = MyLoader()
    var arrNotification = [Notification_data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.tblView.register(UINib(nibName: "NotificarionTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificarionTableViewCell")
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = 60
        self.serverHitNotification()
        // Do any additional setup after loading the view.
    }
  
    @IBAction func deleteAllAction(_ sender: Any) {
        self.serverHitDelete()
    }
    
    // Notification list
    func serverHitNotification() {
        arrNotification.removeAll()
           self.myloader.showLoader(controller: self)
           // email, password, Auth-key
           let dict = ["user_id": fetchString(key: "userID") ] as [String : Any]
           //"ddk_wallet_id":txtFldDDDKWalletID.text!,
           WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "notificationlist", showIndicator: false){ (responseData) in
               DispatchQueue.main.async {
                   self.myloader.removeLoader(controller: self)
                   let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                   let decoder = JSONDecoder()
                   let obj = try! decoder.decode(Notification.self, from: jsonData!)
                    if obj.status == "1" {
                        self.viewMain.isHidden = true
                                  if let arrFeed = obj.data {
                                      _  =   arrFeed.map{
                                          self.arrNotification.append($0)
                                        self.viewMain.isHidden = false
                                      }
                                      self.tblView.reloadData()
                                      self.tblView.delegate = self
                                      self.tblView.dataSource = self
                                  }
                              } else {
                       showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
                   }
               }
           }
       }
    
    // Remove listing
    func serverHitDelete(){
        // email, password, Auth-key
     let dict = ["user_id": fetchString(key: "userID")] as [String : Any]
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "delete_all_notification", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
             let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Notification.self, from: jsonData!)
                if obj.status == "1" {
                    self.arrNotification.removeAll()
                    self.viewMain.isHidden = true
                 print("fsfr")
                }
            }
        }
    }

}

// MARK:- Tableview Delegate and datasourse
extension NotificationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotification.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "NotificarionTableViewCell") as! NotificarionTableViewCell
        cell.lblTitle.text = arrNotification[indexPath.row].notiTitle
        cell.lblMessage.text = arrNotification[indexPath.row].notiMessage
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
