

import UIKit
import IBAnimatable

protocol MyPromocodeAccess {
    func promocodeApply(myData: CoupenList_Data)
}

class CoupenVC: UIViewController {
    
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    var delegate: MyPromocodeAccess?
    var cancelCartID = String()
    var myloader = MyLoader()
    var arrCoupenList = [CoupenList_Data]()
    var selectedCoupenIndex = Int()
    var isCoupen = false
    var cancelReson = String()
    var arrCancelReson = [CancelReson_Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewAlert.isHidden = true
        if isCoupen {
            self.tblView.register(UINib(nibName: "AprilOfferTableViewCell", bundle: nil), forCellReuseIdentifier: "AprilOfferTableViewCell")
            self.tblView.estimatedRowHeight = 160
            self.tblView.rowHeight = UITableView.automaticDimension
            
            serverHitForCoupenList()
        } else {
            self.tblView.register(UINib(nibName: "CancelReSonListTableViewCell", bundle: nil), forCellReuseIdentifier: "CancelReSonListTableViewCell")
            serverHitCanselResonList()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func okAction(_ sender: Any) {
        serverHitForCancelApi()
    }
   
    @IBAction func backgoundAction(_ sender: Any) {
        self.viewAlert.isHidden = true
    }
    
}

// MARK:- Tableview Delegate and datasourse
extension CoupenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCoupen {
            return arrCoupenList.count
        } else {
            return arrCancelReson.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isCoupen {
            let cell = tblView.dequeueReusableCell(withIdentifier: "AprilOfferTableViewCell") as! AprilOfferTableViewCell
            let value = arrCoupenList[indexPath.row]
            cell.lblCode.text =  "\(value.couponCode ?? "")"
            cell.lblOfferName.text = "\(value.couponName ?? "")"
            cell.lblOfferDescription.text = "\(value.couponDescription ?? "")"
            cell.btnApply.addTarget(self, action: #selector(applyAction(sender:)), for: .touchUpInside)
            cell.btnApply.tag = indexPath.row
            return cell
            
        } else {
            let cell = tblView.dequeueReusableCell(withIdentifier: "CancelReSonListTableViewCell") as! CancelReSonListTableViewCell
            let value = arrCancelReson[indexPath.row]
            cell.lblList.text =  "\(value.reason ?? "")"
            return cell
        }
        
        
    }
    
    @objc func applyAction(sender : UIButton) {
      selectedCoupenIndex = sender.tag
      if self.delegate != nil && arrCoupenList[selectedCoupenIndex] != nil {
          let dataToBeSent = self.arrCoupenList[selectedCoupenIndex]
          self.delegate?.promocodeApply(myData: dataToBeSent)
           self.navigationController?.popViewController(animated: true)
      } else {
           self.navigationController?.popViewController(animated: true)
      }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //    selectedCoupenIndex = indexPath.row
        isCancelOption = false
        self.cancelReson = arrCancelReson[indexPath.row].reason!
        viewAlert.isHidden = false
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isCoupen {
            return UITableView.automaticDimension
        } else {
            return 60
        }
        
    }
    
    
    // CanselReson Api
    func serverHitCanselResonList(){
        arrCancelReson.removeAll()
        
        // self.myloader.showLoader(controller: self)
        WebServices().hitAPiTogetDetails(serviceType : baseUrlTest + "cancelling_reasons"){ (responseData) in
            //         self.myloader.removeLoader(controller: self)
            let jsonData = responseData?.toJSONString1().data(using: .utf8)!
            let decoder = JSONDecoder()
            let obj = try! decoder.decode(CancelReson.self, from: jsonData!)
            if obj.status == "1" {
                if let arrFeed = obj.data {
                    _  =   arrFeed.map{
                        self.arrCancelReson.append($0)
                    }
                    self.tblView.delegate = self
                    self.tblView.dataSource = self
                    self.tblView.reloadData()
                    
                }
            }
        }
    }
    
    //CoupenList
    func serverHitForCoupenList(){
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["cart_id": cartID]
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "couponlist", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(CoupenList.self, from: jsonData!)
                if obj.status == "1"{
                    if let arrFeed = obj.data {
                        _  =   arrFeed.map{
                            self.arrCoupenList.append($0)
                        }
                        self.tblView.delegate = self
                        self.tblView.dataSource = self
                        self.tblView.reloadData()
                        
                    }
                } else{
                    // showToast(message: obj.msg ?? "something went wrong", vc: self, normalColor: false)
                }
            }
        }
    }
    
    //Cancle Order Api
    func serverHitForCancelApi(){
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["cart_id": cancelCartID, "reason": cancelReson]
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "delete_order", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(CancelOrder.self, from: jsonData!)
                if obj.status == "1"{
                    self.navigationController?.popViewController(animated: true)
                    showToast(message: obj.message ?? "something went wrong", vc: self, normalColor: false)

                } else{
                    showToast(message: obj.message ?? "something went wrong", vc: self, normalColor: false)
                }
            }
        }
    }
}

