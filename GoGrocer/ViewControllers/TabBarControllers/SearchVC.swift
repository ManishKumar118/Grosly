//
//  SearchVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable

import UIKit
import IBAnimatable
import SDWebImage

class SearchVC: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtFieldSearch: AnimatableTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tblView: UITableView!
    
    var searchTimer: Timer?
    var myloader = MyLoader()
    var arrCaregoryData = [Listing_Data]()
    var varientID = Int()
    var Index = Int()
    var selectIndex = Int()
    var qtyValue = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        //  tblView.register(UINib(nibName: "SearchTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchTableViewCell")
        
        tblView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
        
        searchText()
        
       // self.serverHitForSearch(searchText: "Apple")
        // Do any additional setup after loading the view.
    }
    
    func serverHitForSearch(searchText: String) {
        arrCaregoryData.removeAll()
        self.myloader.showLoader(controller: self)
        // email, password, Auth-key
        let dict = ["value":searchText,"lat":"28.6280","lng":"77.3649", "city":"sonipat"]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "searchproduct", showIndicator: false){ (responseData) in
            
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                guard let jsonData = responseData?.toJSONString1().data(using: .utf8)else{
                    print("errr")
                    return
                }
                //
                do {
                    let resp = try JSONDecoder().decode(Listing.self, from: jsonData)
                    if resp.status == "1" {
                        if let arrFeed = resp.data {
                            _  =   arrFeed.map{
                                self.arrCaregoryData.append($0)
                            }
                            
                            self.tblView.reloadData()
                            self.tblView.delegate = self
                            self.tblView.dataSource = self
                        }
                    }else{
                    }
                }catch{
                    print("error-\(error)")
                }
            }
            
            
            /*
             DispatchQueue.main.async {
             self.myloader.removeLoader(controller: self)
             let jsonData = responseData?.toJSONString1().data(using: .utf8)!
             let decoder = JSONDecoder()
             let obj = try! decoder.decode(CategoryProduct.self, from: jsonData!)
             if obj.status == "1"{
             
             if let arrFeed = obj.data {
             _  =   arrFeed.map{
             self.arrCaregoryData.append($0)
             }
             self.tblView.reloadData()
             self.tblView.delegate = self
             self.tblView.dataSource = self
             }
             }
             }*/
        }
    }
}

//MARK:- UITableViewDelegate, UITableViewDataSource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCaregoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        Index = indexPath.row
        let cell = tblView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
        let value = arrCaregoryData[indexPath.row]
        let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: arrCaregoryData[indexPath.row].productImage))
        
        cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
        cell.lblProduct.text = value.productName
        cell.lblDiscription.text = value.productName
        //  cell.lblOfferPrice.text = "Rs. \(value.mrp ?? 0)"
        cell.lbloffer.text = "Rs.\((value.mrp ?? 0)-(value.price ?? 0)) off"
        cell.lblPrice.text = "Rs. \(value.price ?? 0)"
        cell.lblQuantity.text = "\(value.quantity ?? 0)"
        //cell.lblKg.text = value.unit.rawValue
        cell.lblKg.text = value.unit
        varientID = value.varientID!
        
        if let varientId = value.varientID {
            let productCount = ProductDetailManager.sharedInstance.getProductCount(productId:"\(varientId)")
            print("test :----------------->\(productCount)")
            print("test :----------------->\(varientId)")
            cell.viewAdd.isHidden = (productCount > 0)
            cell.viewAddCart.isHidden = !(productCount > 0)
            cell.lblNumberItem.text = "\(productCount)"
            cell.lblNumberofItem = productCount
            
        } else {
            cell.lblNumberItem.text = "0"
            cell.lblNumberofItem = 0
        }
        
        cell.btnAdd.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        cell.btnMin.addTarget(self, action: #selector(minAction(sender:)), for: .touchUpInside)
        cell.btnIncreese.addTarget(self, action: #selector(Increese(sender:)), for: .touchUpInside)
        cell.btnAdd.tag = Index
        cell.btnMin.tag = Index
        cell.btnIncreese.tag = Index
        
        return cell
        
    }
    
    //MARK:- Cell IBAction
    @objc func addAction(sender : UIButton) {
        selectIndex = sender.tag
        
        let cell = tblView.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? ProductTableViewCell
        varientID = arrCaregoryData[sender.tag].varientID!
        
        cell?.viewAdd.isHidden = true
        cell?.viewAddCart.isHidden = false
        cell?.lblNumberofItem = 1
        qtyValue = cell!.lblNumberofItem
        cell?.lblNumberItem.text = String(describing: qtyValue)
        ProductDetailManager.sharedInstance.onIncreaseTapped(productId: "\(varientID)")
        UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
          serverHitForAddItemCart()
        
    }
    
    @objc func minAction(sender : UIButton) {
        selectIndex = sender.tag
        
        let cell = tblView.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? ProductTableViewCell
        varientID = arrCaregoryData[sender.tag].varientID!
        if cell!.lblNumberofItem > 1 {
            cell?.lblNumberofItem = cell!.lblNumberofItem - 1
            cell?.lblNumberItem.text = String(describing: cell!.lblNumberofItem)
            qtyValue = cell!.lblNumberofItem
        } else {
            cell?.viewAdd.isHidden = false
        }
         serverHitForAddItemCart()
        ProductDetailManager.sharedInstance.onDecreaseTapped(productId: "\(varientID ?? 0)")
        UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
        
    }
    
    //Add cart api
    func serverHitForAddItemCart() {
        if (UserDefaults.standard.object(forKey: "userID") == nil) {
            self.showAlert(title: "Grosly", msg: "Please login to order the product") { }
            return
        }
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
                    let cell = self.tblView.cellForRow(at: IndexPath(item: self.selectIndex, section: 0)) as? ProductTableViewCell
                    for i in obj.cartItems! {
                        cell?.lblPrice.text = "RS. \(i.price ?? 0)"
                    }
                } else {
                    
                }
            }
        }
    }

    
    @objc func Increese(sender : UIButton) {
        selectIndex = sender.tag
        
        let cell = tblView.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? ProductTableViewCell
        print("incress")
        varientID = arrCaregoryData[sender.tag].varientID!
        
        cell?.lblNumberofItem = cell!.lblNumberofItem + 1
        cell?.lblNumberItem.text = String(describing: cell!.lblNumberofItem)
        qtyValue = cell!.lblNumberofItem
        ProductDetailManager.sharedInstance.onIncreaseTapped(productId: "\(varientID)")
        UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
        // serverHitForAddItemCart()
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // return 35
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (UserDefaults.standard.object(forKey: "userID") == nil) {
            self.showAlert(title: "Grosly", msg: "Please login to order the product") { }
            return
        }
        
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        viewController.homeProduct = arrCaregoryData[indexPath.row]
        viewController.homeScreen = true
        viewController.productId = arrCaregoryData[indexPath.row].productID!
        self.navigationController?.pushViewController(viewController, animated: true)
        
        /*
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        //  viewController.CategoryProductDetail = arrCaregoryData[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
         */
    }
    
}

extension SearchVC: UITextFieldDelegate {
    //MARK:- SearchBoxTextChange
    func searchText() -> Void {
        txtFieldSearch?.delegate = self
        txtFieldSearch?.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    //MARK:- textFieldDidChange
    @objc func textFieldDidChange(textField:UITextField) -> Void {
        
        if textField.text!.count >= 3 {
            if self.searchTimer != nil {
                self.searchTimer?.invalidate()
                self.searchTimer = nil
            }
            if textField == txtFieldSearch {
                self.searchTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(searchForKeyword), userInfo: txtFieldSearch!.text, repeats: false)
            }
        }else{
            self.arrCaregoryData.removeAll()
            self.tblView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    //MARK:- searchForKeyword
    @objc func searchForKeyword(timer:Timer) -> Void {
        let keyword = timer.userInfo
        self.serverHitForSearch(searchText:keyword as! String)
    }
}

