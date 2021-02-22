//
//  OrderSummeryVC.swift
//  GoGrocer
//
//  Created by Pooja on 02/06/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import FSCalendar
import SDWebImage

class OrderSummeryVC: UIViewController, UIGestureRecognizerDelegate {
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var lblTotalItem: UILabel!
    @IBOutlet weak var collectionViewItems: UICollectionView!
    @IBOutlet weak var lblTotalItemPrice: UILabel!
    @IBOutlet weak var tblVireTimeslot: UITableView!
    @IBOutlet weak var lblDeliveryPrice: UILabel!
    @IBOutlet weak var calenderCnstHght: NSLayoutConstraint!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    var selectedShowAddressData = [Address_List]()
    var selectedDatesFormat = ""
    var arrTimeslot = [String]()
    var timeSlot = String()
    var selectedIndex = Int()
    var arrCartData = [ShowCart_Data]()

    
    //MARK:- Calender Function
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calender, action: #selector(self.calender.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    //MARK:- viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        tblVireTimeslot.register(UINib(nibName: "TimeSlotTableViewCell", bundle: nil), forCellReuseIdentifier: "TimeSlotTableViewCell")
        self.calender.select(Date())
        self.view.addGestureRecognizer(self.scopeGesture)
        self.calender.scope = .week
        self.calender.setScope(.week, animated: true)
        self.calender.accessibilityIdentifier = "calendar"
         collectionViewItems.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        collectionViewItems.delegate = self
        collectionViewItems.dataSource = self
        self.lblTotalItem.text = "Basket items ( \(arrCartData.count) )"
        self.lblTotalPrice.text = "Rs.\(tolalItemPrice)"
        self.lblTotalItemPrice.text = "Rs.\(tolalItemPrice)"
        selectedDatesFormat = calender.today.map({self.dateFormatter.string(from: $0)})!
//        if selectedDatesFormat != "" {
//            serverHitTimeSlotList()
//        }
//         
        serverHitDelivary()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("\(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        serverHitShowAddress()
    }
    
    // MARK:- IBACtion
    @IBAction func addAddressAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SelectAddress") as! SelectAddress
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if (timeSlot).isEmpty {
            showToastAlert(message: "Please Select time slot", vc: self, normalColor: true)
        } else {
            serverHitForMakeanOrder()
        }
    }
 
}

//MARK:- Calender
extension OrderSummeryVC: FSCalendarDataSource, FSCalendarDelegate{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calenderCnstHght.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        self.calender.today!
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDate.map({self.dateFormatter.string(from: $0)})
      //  selectedDates = calendar.today.map({self.dateFormatter.string(from: $0)})
        selectedDatesFormat = selectedDates!
        print("selected dates is \(selectedDates ?? "")")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        serverHitTimeSlotList()
        
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    
}

//MARK:- UITableView
extension OrderSummeryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTimeslot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tblVireTimeslot.dequeueReusableCell(withIdentifier: "TimeSlotTableViewCell", for: indexPath) as? TimeSlotTableViewCell)!
        let value = arrTimeslot[indexPath.row]
        cell.lblTime.text = "\(value)"
        cell.btnCheckBox.addTarget(self, action: #selector(checkboxAction(sender:)), for: .touchUpInside)
        cell.btnCheckBox.tag = indexPath.row
        
        if selectedIndex == indexPath.row {
            cell.viewCircle.layer.borderWidth = 2
            cell.viewCircle.layer.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
            cell.lblCircle.backgroundColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
        } else {
            cell.viewCircle.layer.borderWidth = 2
            cell.viewCircle.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
            cell.lblCircle.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        return cell
    }
    
    @objc func checkboxAction(sender : UIButton) {
        let cell = self.tblVireTimeslot.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! TimeSlotTableViewCell
        timeSlot = arrTimeslot[sender.tag]
        self.selectedIndex = sender.tag
        tblVireTimeslot.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
        
    }
}

extension OrderSummeryVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCartData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let cell = collectionViewItems.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
        let value = arrCartData[indexPath.item]
        let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: value.varientImage))
        cell.imgBanner.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.imgBanner.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let width = (self.collectionViewItems.frame.height)
        let height = (self.collectionViewItems.frame.height - 10)
        return CGSize(width: width, height: height)
        
        }
    
}
    
  //MARK:- Api
extension OrderSummeryVC {
    // TimeSlot
    func serverHitTimeSlotList(){
        arrTimeslot.removeAll()
        let dict = ["selected_date": selectedDatesFormat]
        WebServices().POSTFunctiontoGetDetails(data: dict, serviceType: "timeslot", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Timeslot.self, from: jsonData!)
                if obj.status == "1" {
                    if let arrFeed = obj.data {
                        _  =   arrFeed.map{
                            self.arrTimeslot.append($0)
                        }
                        self.timeSlot = self.arrTimeslot[0]
                        self.tblVireTimeslot.delegate = self
                        self.tblVireTimeslot.dataSource = self
                        self.tblVireTimeslot.reloadData()
                    }
                    
                } else {
                    showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
                }
            }
            
        }
    }
    
    // MinMax Api
    func serverHitMinmax(){
        WebServices().hitAPiTogetDetails(serviceType : baseUrlTest + "minmax"){ (responseData) in
            let jsonData = responseData?.toJSONString1().data(using: .utf8)!
            let decoder = JSONDecoder()
            let obj = try! decoder.decode(Minmax.self, from: jsonData!)
            if obj.status == "1" {
                showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
            } else {
                showToastAlert(message: obj.message ?? "Something went wrong", vc: self, normalColor: true)
            }
        }
    }
    
    // Delivary Api
    func serverHitDelivary() {
        WebServices().hitAPiTogetDetails(serviceType : baseUrlTest + "delivery_info"){ (responseData) in
            let jsonData = responseData?.toJSONString1().data(using: .utf8)!
            let decoder = JSONDecoder()
            let obj = try! decoder.decode(Delivery.self, from: jsonData!)
            if obj.status == "1" {
                self.lblDeliveryPrice.text = "Rs. \(UnwarppingValue(value: obj.data?.delCharge))"
            } else {
                
            }
        }
    }
    
    func serverHitShowAddress() {
        let dict = ["user_id": userID, "store_id": 23] as [String : Any]
        WebServices().POSTFunctiontoGetDetails(data: dict, serviceType: "show_address", showIndicator: false){ (responseData) in
            DispatchQueue.main.async {
                let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                let decoder = JSONDecoder()
                let obj = try! decoder.decode(Address.self, from: jsonData!)
                if obj.status == "1" {
                for  i in obj.data! {
                    if i.selectStatus == 1 {
                        self.lblName.text = i.receiverName
                        self.lblAddress.text = "\(i.houseNo ?? "")," + "\(i.society ?? "")," + "\(i.city ?? "")," + "\(i.state ?? "")," + "\(i.pincode ?? "")"
                        self.lblNumber.text = "\(i.receiverPhone ?? "")"
                    }
                }
                } else {
                    showToast(message: obj.message ?? "something went wrong", vc: self, normalColor: false)
                }
        }
    }
}
    // Make on Order
        func serverHitForMakeanOrder(){
            // email, password, Auth-key
            let dict = ["time_slot": timeSlot,"user_id": userID, "delivery_date": selectedDatesFormat, "store_id": 11] as [String : Any]
            //"ddk_wallet_id":txtFldDDDKWalletID.text!,
            WebServices().POSTFunctiontoGetDetails(data: dict as [String : Any], serviceType: "ios_make_order", showIndicator: false){ (responseData) in
                DispatchQueue.main.async {
                    let jsonData = responseData?.toJSONString1().data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let obj = try! decoder.decode(Make_On_Order.self, from: jsonData!)
                    if obj.status == "1"{
                        if let cartID = obj.data?.cartID {
                            saveStringInDefault(value: cartID, key: "cartID")
                        } else {
                            saveStringInDefault(value: "", key: "cartID")
                        }
                        
                        if let orderID = obj.data?.orderID {
                            saveStringInDefault(value: orderID, key: "orderID")
                        } else {
                            saveStringInDefault(value: "", key: "orderID")
                        }
                        let storyboard = UIStoryboard.init(name: "Chekout", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
                        self.navigationController?.pushViewController(viewController, animated: true)
                        
                    } else{
                        showToast(message: obj.message ?? "something went wrong", vc: self, normalColor: false)
                    }
                }
            }
        }
    
}



