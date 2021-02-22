

import UIKit
import SDWebImage

class PastOrderVC: UIViewController {
    
    var refreshControl = UIRefreshControl()
    var arrOrderDetail = [PastOrderDetail_Data]()
    var myloader = MyLoader()
    var indexItem = Int()
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UINib(nibName: "OrderListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderListTableViewCell")
        serverHitOrderList()
        tblView.rowHeight = UITableView.automaticDimension
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tblView.addSubview(refreshControl)
//refreshControl.endRefreshing()

        // Do any additional setup after loading the view.
    }
    
  
    
    @objc func refresh(_ sender: AnyObject) {
        tblView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func serverHitOrderList(){
        arrOrderDetail.removeAll()
        self.myloader.showLoader(controller: self)
        let dict = ["user_id": userID]
        
        WebServices().POSTFunctiontoGetDetails(data: dict, serviceType: "ios_com", showIndicator: false){ (responseData) in
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

extension PastOrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOrderDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "OrderListTableViewCell", for: indexPath) as? OrderListTableViewCell)!
        indexItem = indexPath.row

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
        cell.btnReorder.addTarget(self, action: #selector(reOrderAction(sender:)), for: .touchUpInside)
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
    
    @objc func reOrderAction(sender : UIButton) {
//        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "AllProductVC") as! AllProductVC
//        viewController.arrDetailList = arrOrderDetail[indexItem]
        print(sender.tag)
//        viewController.isOrderDetail = true
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func completeAction(sender : UIButton) {
        print(arrOrderDetail[indexItem])
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
