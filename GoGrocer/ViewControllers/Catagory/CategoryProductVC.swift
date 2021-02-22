
import UIKit
import SDWebImage

class CategoryProductVC: UIViewController {
    
    @IBOutlet weak var tblViewLst: UITableView!
    
    var arrCaregoryData = [CategoryProduct_data]()
    var CategoryDetail: ExpendCategory_Data?
    
    var varientID = Int()
    var qtyValue = Int()
    var selectIndex = Int()
    var selectedCatID: Int?
    var isFromTopCollection:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewLst.register(UINib(nibName: "CatagoryProductTableViewCell", bundle: nil), forCellReuseIdentifier: "CatagoryProductTableViewCell")
        if isFromTopCollection {
            serverHitForGettingBusineeDetails(selectedId: selectedCatID!)
        } else {
             guard let catID = CategoryDetail?.catID else {return}
            serverHitForGettingBusineeDetails(selectedId: catID)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func cancleAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- UITableView Delegate, datasource
extension CategoryProductVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCaregoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let Index = indexPath.row
    let cell = tblViewLst.dequeueReusableCell(withIdentifier: "CatagoryProductTableViewCell") as! CatagoryProductTableViewCell
    let value = arrCaregoryData[indexPath.row]
    let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: value.productImage))
    
    cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
    cell.imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
    cell.lblProduct.text = value.productName
    cell.lbloffer.text = "jj"
    cell.btnQuantity.setTitle("45 ltr", for: .normal)
    if value.varients?.count != 0 {
        guard let varientsFirstItemDetail = value.varients?.first else { return cell }
        let (price,description,mrp,varientId) = (varientsFirstItemDetail.price,varientsFirstItemDetail.varientDescription,varientsFirstItemDetail.mrp,varientsFirstItemDetail.varientID)
        cell.lblOfferPrice.text = "Rs. \(mrp ?? 0)"
        cell.lblDiscription.text = description
        cell.lblPrice.text = "Rs. \(price ?? 0)"
        cell.lbloffer.text = "Rs\((mrp ?? 0)-(price ?? 0)) off"
        cell.btnQuantity.setTitle("\(varientsFirstItemDetail.quantity ?? 0) \(varientsFirstItemDetail.unit ?? "ll")", for: .normal)
        varientID = varientId!
        
    }
    
    if let varientId:Int = varientID{
        let productCount = ProductDetailManager.sharedInstance.getProductCount(productId:"\(varientId)")
        print(productCount)
        cell.viewAdd.isHidden = (productCount > 0)
       // cell.viewAddCart.isHidden = !(productCount > 0)
        cell.lblQuantity.text = "\(productCount)"
        cell.lblNumberofItem = productCount

    } else {
        cell.lblQuantity.text = "0"
        cell.lblNumberofItem = 0
        
    }
    
    cell.btnQuantity.addTarget(self, action: #selector(tapSection(sender:)), for: .touchUpInside)
    cell.btnAdd.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
    cell.btnMin.addTarget(self, action: #selector(minAction(sender:)), for: .touchUpInside)
    cell.btnIncreese.addTarget(self, action: #selector(Increese(sender:)), for: .touchUpInside)
    cell.btnAdd.tag = Index
    cell.btnMin.tag = Index
    cell.btnIncreese.tag = Index
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Index = indexPath.row
        let cell = tblViewLst.dequeueReusableCell(withIdentifier: "CatagoryProductTableViewCell") as! CatagoryProductTableViewCell
        let value = arrCaregoryData[indexPath.row]
        let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: value.productImage))
        
        cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
        cell.lblProduct.text = value.productName
        if value.varients?.count != 0 {
            guard let varientsFirstItemDetail = value.varients?.first else { return cell }
            let (price,description,mrp,varientId) = (varientsFirstItemDetail.price,varientsFirstItemDetail.varientDescription,varientsFirstItemDetail.mrp,varientsFirstItemDetail.varientID)
            cell.lblOfferPrice.text = "Rs. \(mrp ?? 0)"
            cell.lblDiscription.text = description
            cell.lblPrice.text = "Rs. \(price ?? 0)"
            varientID = varientId!
            
        }
        
        if let varientId:Int = varientID{
            let productCount = ProductDetailManager.sharedInstance.getProductCount(productId:"\(varientId)")
            print(productCount)
            cell.viewAdd.isHidden = (productCount > 0)
           // cell.viewAddCart.isHidden = !(productCount > 0)
            cell.lblQuantity.text = "\(productCount)"
            cell.lblNumberofItem = productCount

        } else {
            cell.lblQuantity.text = "0"
            cell.lblNumberofItem = 0
            
        }
        
        cell.btnQuantity.addTarget(self, action: #selector(tapSection(sender:)), for: .touchUpInside)
        cell.btnAdd.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        cell.btnMin.addTarget(self, action: #selector(minAction(sender:)), for: .touchUpInside)
        cell.btnIncreese.addTarget(self, action: #selector(Increese(sender:)), for: .touchUpInside)
        cell.btnAdd.tag = Index
        cell.btnMin.tag = Index
        cell.btnIncreese.tag = Index
            return cell
        }*/
        
        @objc func addAction(sender : UIButton) {
            selectIndex = sender.tag

            let cell = tblViewLst.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? CatagoryProductTableViewCell
                  print("add")
            varientID = (arrCaregoryData[sender.tag].varients?.first?.varientID)!

            cell?.viewAdd.isHidden = true
         //   cell?.viewAddCart.isHidden = false
            cell?.lblNumberofItem = 1
            qtyValue = cell!.lblNumberofItem
            cell?.lblQuantity.text = String(describing: qtyValue)
            ProductDetailManager.sharedInstance.onIncreaseTapped(productId: "\(varientID)")
            UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
            serverHitForAddItemCart()
              }
           
        @objc func minAction(sender : UIButton) {
           
                  print("min")
            selectIndex = sender.tag

            let cell = tblViewLst.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? CatagoryProductTableViewCell
            varientID = (arrCaregoryData[sender.tag].varients?.first?.varientID)!
            if cell!.lblNumberofItem > 1 {
            cell?.lblNumberofItem = cell!.lblNumberofItem - 1
            cell?.lblQuantity.text = String(describing: cell!.lblNumberofItem)
            qtyValue = cell!.lblNumberofItem
            } else {
                cell?.viewAdd.isHidden = false
            }
            serverHitForAddItemCart()
            ProductDetailManager.sharedInstance.onDecreaseTapped(productId: "\(varientID ?? 0)")
            UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
            
              }
           
        @objc func Increese(sender : UIButton) {
                  print("incress")
            selectIndex = sender.tag

            let cell = tblViewLst.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? CatagoryProductTableViewCell
            print("incress")
            varientID = (arrCaregoryData[sender.tag].varients?.first?.varientID)!
            cell?.lblNumberofItem = cell!.lblNumberofItem + 1
            cell?.lblQuantity.text = String(describing: cell!.lblNumberofItem)
            qtyValue = cell!.lblNumberofItem
            ProductDetailManager.sharedInstance.onIncreaseTapped(productId: "\(varientID)")
            UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        viewController.CategoryProductDetail = arrCaregoryData[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    func serverHitForGettingBusineeDetails(selectedId:Int) {
        //   self.myloader.showLoader(controller: self)
        arrCaregoryData.removeAll()
        
       // guard let catID = CategoryDetail?.catID else {return}
        
        // email, password, Auth-key
        let dict = ["cat_id": selectedId, "lat":"28.6280","lng":"77.3649", "city":"sonipat"] as [String : Any]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "cat_product", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                // self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(CategoryProduct.self, from: jsonData!)
                if obj.status == "1" {
                    if let arrFeed = obj.data {
                        _  =   arrFeed.map{
                            self.arrCaregoryData.append($0)
                        }
                        self.tblViewLst.delegate = self
                        self.tblViewLst.dataSource = self
                        self.tblViewLst.reloadData()
                    }
                }
            }
        }
    }
    
    //Add cart api
       func serverHitForAddItemCart() {
           // email, password, Auth-key
           let dict = ["user_id":userID, "varient_id":varientID, "qty":qtyValue] as [String : Any]
           //"ddk_wallet_id":txtFldDDDKWalletID.text!,
           WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "ios_cart_add", showIndicator: false){ (responseData) in
               DispatchQueue.main.async {
                   let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                   let decoder = JSONDecoder()
                   let obj = try! decoder.decode(AddCart.self, from: jsonData!)
                   if obj.status == "1" {
                       let cell = self.tblViewLst.cellForRow(at: IndexPath(item: self.selectIndex, section: 0)) as? CatagoryProductTableViewCell
                       for i in obj.cartItems! {
                           cell?.lblPrice.text = "RS. \(i.price ?? 0)"
                       }
                   } else {
                       
                   }
               }
           }
       }
    
}

