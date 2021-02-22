//
//  CartVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import SDWebImage

class CartVC: UIViewController {
    
    @IBOutlet weak var viewCart: UIView!
    @IBOutlet weak var tblViewCart: UITableView!
    @IBOutlet weak var LblTotalPrice: UILabel!
    @IBOutlet weak var lblNumberItem: UILabel!
    
    var arrShowCart = [ShowCart_Data]()
    var myloader = MyLoader()
    var varientID = Int()
    var qtyValue = Int()
    var selectIndex = Int()
    var arrAddCart = [CartItem]()
    var Index = Int()
    var selectIndexItem = Int()
    var tolalCartPrice = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        tblViewCart.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        serverHitForShowCart()
       
        
    }
    
    
    @IBAction func shopNowAction(_ sender: UIButton) {
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
       let storyboard = UIStoryboard.init(name: "Chekout", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "OrderSummeryVC") as! OrderSummeryVC
        viewController.arrCartData = arrShowCart
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension CartVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrShowCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Index = indexPath.row
        let cell = tblViewCart.dequeueReusableCell(withIdentifier: "CartTableViewCell") as! CartTableViewCell
        let value = arrShowCart[indexPath.row]
        let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: value.varientImage))
        cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
        cell.lblProduct.text = value.productName
        cell.lblPrice.text = "RS. \(value.price ?? 0)"
        cell.lblNumberItem.text = "\(value.qty ?? 0)"
        cell.lblQuantity.text = "\(value.quantity ?? 0)" + "\(value.unit ?? "")"
        cell.number = value.qty ?? 0
        cell.btnAdd.addTarget(self, action: #selector(Increese(sender:)), for: .touchUpInside)
        cell.btnMin.addTarget(self, action: #selector(minAction(sender:)), for: .touchUpInside)
        cell.bntnCancle.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
        cell.btnAdd.tag = Index
        cell.btnMin.tag = Index
        cell.bntnCancle.tag = Index
        cell.bntnCancle.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndexItem = indexPath.row
    }
    
    @objc func deleteAction(sender : UIButton) {
        selectIndex = sender.tag
        varientID = arrShowCart[selectIndex].varientID!
        serverHitForDeleteItemCart()
    }
    
    @objc func minAction(sender : UIButton) {
        selectIndex = sender.tag
        let cell = tblViewCart.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? CartTableViewCell
        varientID = arrShowCart[sender.tag].varientID!
        cell?.number = cell!.number - 1
        cell?.lblNumberItem.text = String(describing: cell!.number)
        qtyValue = cell!.number
        serverHitForAddItemCart()
    }
    
    @objc func Increese(sender : UIButton) {
        selectIndex = sender.tag
        let cell = tblViewCart.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? CartTableViewCell
        print("incress")
        varientID = arrShowCart[sender.tag].varientID!
        cell?.number = cell!.number + 1
        cell?.lblNumberItem.text = String(describing: cell!.number)
        qtyValue = cell!.number
        serverHitForAddItemCart()
    }
    
    
    @objc func tapSection(sender: UIButton) {
        let navController = UINavigationController.init(rootViewController: self.storyboard!.instantiateViewController(withIdentifier: "CategoryQuantityVC"))
        navController.modalPresentationStyle = .custom
        navController.modalTransitionStyle = .crossDissolve
        self.present(navController, animated: true, completion: {})
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func serverHitForShowCart() {
        arrShowCart.removeAll()
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["user_id":userID]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "show_cart", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(ShowCart.self, from: jsonData!)
                
                if obj.status == "1" {
                    self.viewCart.isHidden = true
                    if let arrFeed = obj.data {
                        _  =   arrFeed.map{
                            self.arrShowCart.append($0)
                        }
                        self.tblViewCart.delegate = self
                        self.tblViewCart.dataSource = self
                        self.tblViewCart.reloadData()
                        self.lblNumberItem.text = "\(self.arrShowCart.count) Total Items:"
                        self.LblTotalPrice.text = "Rs. \(UnwarppingValue(value: obj.totalPrice))"
                        tolalItemPrice = obj.totalPrice ?? 0
                    }
                } else {
                    self.viewCart.isHidden = false
                }
            }
        }
    }
    
    func serverHitForAddItemCart() {
        // email, password, Auth-key
        let dict = ["user_id":userID, "varient_id":varientID, "qty":qtyValue] as [String : Any]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "ios_cart_add", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(AddCart.self, from: jsonData!)
                if obj.status == "1" {
                    self.LblTotalPrice.text = "Rs. \(UnwarppingValue(value: obj.totalPrice))"
                    let cell = self.tblViewCart.cellForRow(at: IndexPath(item: self.selectIndex, section: 0)) as? CartTableViewCell
                    for i in obj.cartItems! {
                        cell?.lblPrice.text = "Rs. \(i.price ?? 0)"
                    }
                } else {
                    
                }
            }
        }
    }
    
    func serverHitForDeleteItemCart() {
        // email, password, Auth-key
        let dict = ["user_id":userID, "varient_id":varientID] as [String : Any]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "del_from_cart", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(AddCart.self, from: jsonData!)
                if obj.status == "1" {
                    self.arrShowCart.remove(at: self.selectIndexItem)
                    self.tblViewCart.reloadData()
                    self.serverHitForAddItemCart()
                }
            }
        }
    }
    
}


