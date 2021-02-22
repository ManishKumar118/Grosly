//
//  SelectAddress.swift
//  GoGrocer
//
//  Created by Pooja on 02/06/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit

protocol MyAddressDelegateProtocol {
    func sendDataToFirstViewController(myData: Address_List)
}

class SelectAddress: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!
    
    var delegate: MyAddressDelegateProtocol?

    var arrAddress = [Address_List]()
    var myloader = MyLoader()
    var selectedIndex = -1
    var AddressId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UINib(nibName: "AddressListTableViewCell", bundle: nil), forCellReuseIdentifier: "AddressListTableViewCell")
        self.serverHitOrderList()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addAddressAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
        viewController.isAddAddress = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if self.delegate != nil && arrAddress[selectedIndex] != nil {
            let dataToBeSent = self.arrAddress[selectedIndex]
            self.delegate?.sendDataToFirstViewController(myData: dataToBeSent)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func serverHitOrderList(){
        arrAddress.removeAll()
        self.myloader.showLoader(controller: self)
        let dict = ["user_id": userID, "store_id": 23] as [String : Any]
        WebServices().POSTFunctiontoGetDetails(data: dict, serviceType: "show_address", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Address.self, from: jsonData!)
                if obj.status == "1" {
                    if let arrFeed = obj.data {
                        _  =   arrFeed.map{
                            self.arrAddress.append($0)
                        }
                        self.tblView.delegate = self
                        self.tblView.dataSource = self
                        self.tblView.reloadData()
                    }
                }
            }
            
        }
    }
    
   func serverHitSelectAddress() {
       let dict = ["address_id": AddressId]
    print(dict)
       WebServices().POSTFunctiontoGetDetails(data: dict, serviceType: "select_address", showIndicator: false){ (responseData) in
           DispatchQueue.main.async {
      //         self.myloader.removeLoader(controller: self)
               let jsonData = responseData?.toJSONString1().data(using: .utf8)!
               let decoder = JSONDecoder()
               let obj = try! decoder.decode(Address.self, from: jsonData!)
               if obj.status == "1" {
                   self.navigationController?.popViewController(animated: true)
                       }
                       
                   }
               }
           }
           
    
}

extension SelectAddress: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrAddress.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "AddressListTableViewCell", for: indexPath) as? AddressListTableViewCell
        let value = arrAddress[indexPath.row]
       
        cell?.lblName.text = value.receiverName
        cell?.lblAddress1.text = "\(value.houseNo ?? "")" + "\(value.society ?? "")" + "\(value.city ?? "")" + "\(value.state ?? "")" + "\(value.pincode ?? "")"
        cell?.lblAddress2.text = "\(value.houseNo ?? "")" + "\(value.society ?? "")" + "\(value.city ?? "")" + "\(value.state ?? "")" + "\(value.pincode ?? "")"
        
        cell?.btnEdit.addTarget(self, action: #selector(editAction(sender:)), for: .touchUpInside)
        cell?.btnCheckBox.addTarget(self, action: #selector(checkboxAction(sender:)), for: .touchUpInside)
        cell?.btnEdit.tag = indexPath.row
        cell?.btnCheckBox.tag = indexPath.row

        if selectedIndex == indexPath.row {
            cell?.viewCircle.layer.borderWidth = 2
            cell?.viewCircle.layer.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            cell?.lblCircle.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
               } else {
            cell?.viewCircle.layer.borderWidth = 2
            cell?.viewCircle.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            cell?.lblCircle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
               }

        return cell!
    }
    
    @objc func checkboxAction(sender : UIButton) {
        let cell = self.tblView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! AddressListTableViewCell
        self.selectedIndex = sender.tag
        self.AddressId = self.arrAddress[selectedIndex].addressID ?? 0
        
         tblView.reloadData()
        serverHitSelectAddress()
              
    }
    
    @objc func editAction(sender : UIButton) {
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AddressVC") as! AddressVC
        viewController.editAddress =  arrAddress[selectedIndex]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    
}
