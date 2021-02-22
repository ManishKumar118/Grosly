
import UIKit
import SDWebImage

class AllProductVC: UIViewController {

    @IBOutlet weak var listingTblView: UITableView!
    @IBOutlet weak var lblNavigationTitle: UILabel!
    
    var Index = Int()
    var selectedItem = Int()
    var arrDetailList: PastOrderDetail_Data?
    var isOrderDetail = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isOrderDetail {
            self.listingTblView.register(UINib(nibName: "OrderDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderDetailsTableViewCell")
            lblNavigationTitle.text = "Order Detail"
            listingTblView.delegate = self
            listingTblView.dataSource = self
        } else {
           listingTblView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductTableViewCell")
            listingTblView.delegate = self
            listingTblView.dataSource = self
        }

//
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }

}


// MARK:- Tableview Delegate and datasourse
extension AllProductVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOrderDetail {
            return arrDetailList?.varient?.count ?? 0
        } else {
             return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        Index = indexPath.row
        if isOrderDetail {
           let cell = (listingTblView.dequeueReusableCell(withIdentifier: "OrderDetailsTableViewCell", for: indexPath) as? OrderDetailsTableViewCell)!
            let value = arrDetailList?.varient?[indexPath.row]
            let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: value?.varientImage))
            cell.imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
            cell.lblProductName.text =  "\(value?.productName ?? "")"
            cell.lblDescription.text =  "\(value?.varientDescription ?? "")"
            cell.lblPrice.text = "Rs. \(value?.price ?? 0)"
            cell.lblQuantity.text = "Qty - \(value?.quantity ?? 0)" + ((value?.unit)!)
            return cell


        } else {
             let cell = listingTblView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
//       cell.btnMin.addTarget(self, action: #selector(decrement(sender:)), for: .touchUpInside)
//       cell.btnAdd.addTarget(self, action: #selector(increment(sender:)), for: .touchUpInside)
//        cell.btnDecreseQuantity.tag = indexPath.row
//        cell.btnIncreseQuantity.tag = indexPath.row
                    return cell
        }

       
    }
    @objc func goToNextScreen(selectedDate: Date? = nil) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailVC
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isOrderDetail {
            return 150
        } else {
             return 150
      }
    }
    
}
