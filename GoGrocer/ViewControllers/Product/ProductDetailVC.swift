


import UIKit
import IBAnimatable
import SDWebImage

class ProductDetailVC: UIViewController {
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewAddCart: UIView!
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblkg: UILabel!
    @IBOutlet weak var lblMrp: UILabel!
    
    @IBOutlet weak var lblKgQuantity: UILabel!
    var myloader = MyLoader()
    
    var homeScreen = false
    var CategoryProductDetail: CategoryProduct_data?
    var homeProduct: Listing_Data?
    var arrVarients = [productVarients_Data]()
    
    var varientID = Int()
    var lblNumberofItem = Int()
    var qtyValue = Int()
    var Index = Int()
    var selectIndex = Int()
    var productId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib(nibName: "QuantityTableViewCell", bundle: nil), forCellReuseIdentifier: "QuantityTableViewCell")
        
        self.viewAddCart.isHidden = true
        self.viewAdd.isHidden = false
        
        if homeScreen {
            self.productDetail()
            self.serverHitVarientList()
        } else {
            productCategoryDetail()
            self.tblView.delegate = self
            self.tblView.dataSource = self
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBAction
    @IBAction func decreeseAction(_ sender: UIButton) {
        
        if lblNumberofItem > 1 {
            lblNumberofItem = lblNumberofItem - 1
            lblQuantity.text = String(describing: lblNumberofItem)
            qtyValue = lblNumberofItem
        } else {
            viewAdd.isHidden = false
        }
        serverHitForAddItemCart()
        ProductDetailManager.sharedInstance.onDecreaseTapped(productId: "\(varientID )")
        UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
        
    }
    
    @IBAction func increesAction(_ sender: UIButton) {
        
        lblNumberofItem = lblNumberofItem + 1
        lblQuantity.text = String(describing: lblNumberofItem)
        qtyValue = lblNumberofItem
        serverHitForAddItemCart()
        ProductDetailManager.sharedInstance.onIncreaseTapped(productId: "\(varientID )")
        UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
        
    }
    
    @IBAction func cancleAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addAction(_ sender: UIButton) {
        
        viewAdd.isHidden = true
        viewAddCart.isHidden = false
        lblNumberofItem = 1
        qtyValue = lblNumberofItem
        lblQuantity.text = String(describing: qtyValue)
        ProductDetailManager.sharedInstance.onIncreaseTapped(productId: "\(varientID)")
        UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
        serverHitForAddItemCart()
        
    //    aryCustomProduct
        
    }
    //MARK:- CATEGORY PRODUCT DETAIL
    func productCategoryDetail() {
        if CategoryProductDetail?.varients?.count != 0 {
            
            guard let varientsFirstItemDetail = CategoryProductDetail?.varients?.first else { return }
            
            let (unit,description,price,mrp,quantity,varientId) = (varientsFirstItemDetail.unit,varientsFirstItemDetail.varientDescription,varientsFirstItemDetail.price,varientsFirstItemDetail.mrp,varientsFirstItemDetail.quantity,varientsFirstItemDetail.varientID)
            lblPrice.text = "Rs. \(price ?? 0)"
            lblDiscription.text = description
           // lblkg.text = unit.rawValue By PS
            lblkg.text = unit
            lblKgQuantity.text = "\(quantity ?? 0)"
            lblMrp.text = "\(mrp ?? 0)"
            varientID = varientId ?? 0
            
        }
        if let varientId = CategoryProductDetail?.varients?.first?.varientID {
            let productCount = ProductDetailManager.sharedInstance.getProductCount(productId:"\(varientId)")
            print(productCount)
            viewAdd.isHidden = (productCount > 0)
            viewAddCart.isHidden = !(productCount > 0)
            lblQuantity.text = "\(productCount)"
            lblNumberofItem = productCount
        }
        
        self.lblProductName.text = CategoryProductDetail?.productName
        let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: CategoryProductDetail?.productImage))
        imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
    }
    
    //MARK:- PRODUCT DETAIL
    func productDetail() {
        self.varientID = (homeProduct?.varientID)!
        lblPrice.text = "Rs. \(homeProduct?.price ?? 0)"
        lblDiscription.text = homeProduct?.datumDescription
        lblKgQuantity.text = "\(homeProduct?.quantity ?? 0)"
       // lblkg.text = (homeProduct?.unit).map { $0.rawValue }
        lblMrp.text = "\(homeProduct?.mrp ?? 0)"
        self.lblProductName.text = homeProduct?.productName
        let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: homeProduct?.productImage))
        imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
        
        if let varientId = homeProduct?.varientID {
            let productCount = ProductDetailManager.sharedInstance.getProductCount(productId:"\(varientId)")
            print(productCount)
            viewAdd.isHidden = (productCount > 0)
            viewAddCart.isHidden = !(productCount > 0)
            lblQuantity.text = "\(productCount)"
            lblNumberofItem = productCount
        }
    }
    
}


// MARK:- Tableview Delegate and datasourse
extension ProductDetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeScreen {
            return arrVarients.count
        } else {
            return (CategoryProductDetail?.varients?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblView.dequeueReusableCell(withIdentifier: "QuantityTableViewCell") as! QuantityTableViewCell
        Index = indexPath.row
        
        if homeScreen  {
            let value = arrVarients[indexPath.row]
            let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: value.varientImage))
            cell.imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
            cell.lblMrp.text =  "Rs. \(value.mrp ?? 0)"
            cell.lblPrice.text = "Rs. \(value.price ?? 0)"
            cell.lblQuantity.text = "\(value.quantity)"
            cell.lblKg.text = (value.unit)
            
            if let varientId:Int = value.varientID {
                let productCount = ProductDetailManager.sharedInstance.getProductCount(productId:"\(varientId)")
                print(productCount)
                cell.viewAdd.isHidden = (productCount > 0)
                cell.viewAddCart.isHidden = !(productCount > 0)
                cell.lblNumberItem.text = "\(productCount)"
                cell.lblNumberofItem = productCount

            } else {
                cell.lblNumberItem.text = "0"
                cell.lblNumberofItem = 0
            }

        } else {
            let value = CategoryProductDetail?.varients?[indexPath.row]
            let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: value?.varientImage))
            cell.imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
            cell.lblMrp.text =  "Rs. \(value?.mrp ?? 0)"
            cell.lblPrice.text = "Rs. \(value?.price ?? 0)"
            cell.lblQuantity.text = "\(value?.quantity ?? 0)"
           // cell.lblKg.text = (value?.unit).map { $0.rawValue } // BY PS
            
            cell.lblKg.text = (value?.unit).map { $0 }
            
            if let varientId = value?.varientID {
                let productCount = ProductDetailManager.sharedInstance.getProductCount(productId:"\(varientId)")
                print(productCount)
                cell.viewAdd.isHidden = (productCount > 0)
                cell.viewAddCart.isHidden = !(productCount > 0)
                cell.lblNumberItem.text = "\(productCount)"
                cell.lblNumberofItem = productCount

            } else {
                cell.lblNumberItem.text = "0"
                cell.lblNumberofItem = 0
            }
        }
        
        cell.btnAdd.addTarget(self, action: #selector(addAction(sender:)), for: .touchUpInside)
        cell.btnMin.addTarget(self, action: #selector(minAction(sender:)), for: .touchUpInside)
        cell.btnIncreese.addTarget(self, action: #selector(Increese(sender:)), for: .touchUpInside)
        cell.btnAdd.tag = Index
        cell.btnMin.tag = Index
        cell.btnIncreese.tag = Index
        
        return cell
    }
    
    @objc func addAction(sender : UIButton) {
        selectIndex = sender.tag
      //   Variables.sharedVariables.aryCustomProduct.append(arrVarients[selectIndex])
        let cell = tblView.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? QuantityTableViewCell
        varientID = arrVarients[sender.tag].varientID ?? 0
        
        cell?.viewAdd.isHidden = true
        cell?.viewAddCart.isHidden = false
        cell?.lblNumberofItem = 1
        qtyValue = cell!.lblNumberofItem
        cell?.lblNumberItem.text = String(describing: qtyValue)
        ProductDetailManager.sharedInstance.onIncreaseTapped(productId: "\(varientID)")
        UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
        serverHitForAddItemCart()
        
        let dict1 = ["product_id":arrVarients[sender.tag].storeID,
                            "product_name":"product_name",
                            "varient_id":varientID,
                            "title":"title",
                            "price":"price",
                            "deal_price":"deal_price",
                            "product_image":"",
                            "unit_value":"unit_value",
                            "increament":"0",
                            "rewards":"0",
                            "stock":"0",
                            "product_description":"qtyValue"]
                   as [String : Any]

        
       
    }
    
    @objc func minAction(sender : UIButton) {
        selectIndex = sender.tag
        
        let cell = tblView.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? QuantityTableViewCell
        varientID = arrVarients[sender.tag].varientID ?? 0
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
    
    @objc func Increese(sender : UIButton) {
        let cell = tblView.cellForRow(at: IndexPath(item: sender.tag, section: 0)) as? QuantityTableViewCell
        print("incress")
        selectIndex = sender.tag
        varientID = arrVarients[sender.tag].varientID ?? 0
        
        cell?.lblNumberofItem = cell!.lblNumberofItem + 1
        cell?.lblNumberItem.text = String(describing: cell!.lblNumberofItem)
        qtyValue = cell!.lblNumberofItem
        ProductDetailManager.sharedInstance.onIncreaseTapped(productId: "\(varientID)")
        UserDefaults.standard.set(ProductDetailManager.sharedInstance.productDetails, forKey: "productDetails")
        
        serverHitForAddItemCart()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    //MARK:- API
    func serverHitVarientList(){
        arrVarients.removeAll()
        guard let productId = homeProduct?.productID else { return }
        let dict = ["product_id" : productId, "lat":"28.6280","lng":"77.3649", "city":"sonipat"] as [String : Any]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "varient", showIndicator: false){ (responseData) in
            let jsonData = responseData?.toJSONString1().data(using: .utf8)!
            let decoder = JSONDecoder()
            let obj = try! decoder.decode(ProductVarient.self, from: jsonData!)
            if obj.status == "1" {
                //   if obj.data!.count > 0 {
                if let arrFeed = obj.data {
                    _  =   arrFeed.map{
                        self.arrVarients.append($0)
                    }
                    self.tblView.delegate = self
                    self.tblView.dataSource = self
                    self.tblView.reloadData()
                    
                }
            }
        }
    }
    
    // AddtoCart
    /*
    func serverHitForAddItemCart() {
        // email, password, Auth-key
        //"product_id":homeProduct.productID!
        let dict = ["user_id":userID, "varient_id":varientID, "qty":qtyValue,"product_id":productId] as [String : Any]
        //"ddk_wallet_id":txtFldDDDKWalletID.text!,
        
      //  "product_varient" replaced in to varient
        WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "varient", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                self.myloader.removeLoader(controller: self)
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(AddCart.self, from: jsonData!)
                if obj.status == "1" {
                    let cell = self.tblView.cellForRow(at: IndexPath(item: self.selectIndex, section: 0)) as? CartTableViewCell
                    for i in obj.cartItems! {
                        cell?.lblPrice.text = "RS. \(i.price ?? 0)"
                    }
                } else {
                    
                }
            }
        }
    }*/
    
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
                     let cell = self.tblView.cellForRow(at: IndexPath(item: self.selectIndex, section: 0)) as? CartTableViewCell
                     for i in obj.cartItems! {
                         cell?.lblPrice.text = "RS. \(i.price ?? 0)"
                     }
                 } else {
                     
                 }
             }
         }
     }

    
}

