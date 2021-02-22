//
//  PendingVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/06/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable

class PendingVC: UIViewController {
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewAlertVC: UIView!
    
    var orderStatus = String()
    var arrOrderDetail = [PastOrderDetail_Data]()
    var myloader = MyLoader()
    var deletCartId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewAlertVC.isHidden = true

        self.tblView.register(UINib(nibName: "OrderListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderListTableViewCell")
        serverHitOrderList()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblView.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBaction
    @objc func refresh(_ sender: AnyObject) {
        tblView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @IBAction func noAction(_ sender: UIButton) {
        viewAlertVC.isHidden = true
        
    }
    
    @IBAction func yesAction(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CoupenVC") as! CoupenVC
        viewController.cancelCartID = self.deletCartId
         self.viewAlertVC.isHidden = false
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    //MARK:- API
    func serverHitOrderList(){
        arrOrderDetail.removeAll()
        self.myloader.showLoader(controller: self)
        let dict = ["user_id": userID]
        
        WebServices().POSTFunctiontoGetDetails(data: dict, serviceType: "ios_on", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(PastOrderDetail.self, from: jsonData!)
                if obj.status == "1" {
                    if let arrFeed = obj.data {
                        _  =   arrFeed.map{
                            self.arrOrderDetail.append($0)
                    
                        }
                        self.tblView.delegate = self
                        self.tblView.dataSource = self
                        self.tblView.reloadData()
                    }
                }
            }
        }
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension PendingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrderDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "OrderListTableViewCell", for: indexPath) as? OrderListTableViewCell)!
        
        let value = arrOrderDetail[indexPath.row]
        cell.lblOrdermode.text = "\(value.paymentMethod ?? "")"
        cell.lblOrder.text = "Payment:- \(value.cartID ?? "")"
        cell.lblPlaceOn.text = "Place On - \(value.deliveryDate ?? "")"
        cell.lblTime.text = "Time - \(value.timeSlot ?? "")"
        cell.lblTotalQuantity.text = "Item Qty - \(value.paymentMethod ?? "")"
        cell.lblOrderAmount.text = "Order Amount - \(value.price ?? 0)"
        cell.lblPaybleAmount.text = "Payable Amount - \(value.remainingAmount ?? 0)"
        cell.lblPayment.text = "Payment:- \(value.paymentStatus ?? "")"
        cell.lblTracking.text = "Tracking Status On \(value.deliveryDate ?? "")"
        
        orderStatus = value.orderStatus ?? ""
        if orderStatus == "Cancelled" {
            cell.btnReorder.setTitle("Reorder", for: .normal)
            cell.btnComplete.setTitle("Cancelled", for: .normal)
            cell.btnReorder.backgroundColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
            cell.btnComplete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)

        } else {
            cell.btnReorder.setTitle("Cancel", for: .normal)
            cell.btnComplete.setTitle("Pending", for: .normal)
            cell.btnComplete.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.btnReorder.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)

        }
        
        cell.btnReorder.addTarget(self, action: #selector(cancelAction(sender:)), for: .touchUpInside)
        cell.btnComplete.addTarget(self, action: #selector(completeAction(sender:)), for: .touchUpInside)
        cell.btnOrder.addTarget(self, action: #selector(orderDetailAction(sender:)), for: .touchUpInside)
        cell.btnReorder.tag = indexPath.row
        cell.btnComplete.tag = indexPath.row
        cell.btnOrder.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 460//UITableView.automaticDimension
    }
    
    @objc func cancelAction(sender : UIButton) {
        deletCartId = self.arrOrderDetail[sender.tag].cartID ?? ""
        isCancelOption = true
        self.viewAlertVC.isHidden = false
    }
    
    @objc func completeAction(sender : UIButton) {
        // print(arrOrderDetail[indexItem])
    }
    
    @objc func orderDetailAction(sender : UIButton) {
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "AllProductVC") as! AllProductVC
        viewController.arrDetailList = arrOrderDetail[sender.tag]
        viewController.isOrderDetail = true
        print(sender.tag)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
