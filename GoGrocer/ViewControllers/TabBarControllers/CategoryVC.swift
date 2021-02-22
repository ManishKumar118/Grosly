//
//  CategoryVC.swift
//  GoGrocer
//
//  Created by Pooja on 29/05/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import SDWebImage
import RandomColorSwift

class CategoryVC: UIViewController {
    
    var colors: [UIColor]!
    
    var count = 99
    var hue: Hue = .random
    var luminosity: Luminosity = .bright
    
    @IBOutlet weak var tblViewCategory: UITableView!
    
    var arrCategory = [ExpendCategory_Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        tblViewCategory.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryTableViewCell")
        tblViewCategory.register(UINib(nibName: "ExpandTableViewCell", bundle: nil), forCellReuseIdentifier: "ExpandTableViewCell")
        tblViewCategory.delegate = self
        tblViewCategory.dataSource = self
        serverHitBottomBannerList()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        refresh()
        
    }
    
    func refresh() {
        colors = randomColors(count: count, hue: hue, luminosity: luminosity)
        tblViewCategory.reloadData()
    }
    
}
// MARK:- Tableview Delegate and datasourse
extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrCategory[section].opened {
            //return arrCategory[section].sectionData.count + 1
            return arrCategory[section].subcategory!.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dataIndex = indexPath.row - 1
        if indexPath.row == 0 {
            
            guard let cell = tblViewCategory.dequeueReusableCell(withIdentifier: "ExpandTableViewCell", for: indexPath) as? ExpandTableViewCell else { return UITableViewCell() }
            //    let value = arrCategory[indexPath.row]
            let imageUrl = URL(string : ImgBaseUrl +  UnwarppingValue(value: arrCategory[indexPath.section].image))
            cell.imgProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
            cell.imgProduct.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ""))
            cell.lblCategoryName.text = arrCategory[indexPath.section].datumDescription
            cell.lblCategoryName.textColor = UIColor.black
            cell.viewMain.backgroundColor = UIColor.white//colors[indexPath.section]
            let BottomCnst =  arrCategory[indexPath.section].opened ? -20.0 : 5.0
            cell.viewBottomCnst.constant = CGFloat(BottomCnst)
            return cell
        } else {
            guard let cell = tblViewCategory.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
            cell.lblCategory.text = arrCategory[indexPath.section].subcategory?[dataIndex].datumDescription
            let topCnst = indexPath.row == 1 ? -25.0 : -20.0
            let BottomCnst = indexPath.row == arrCategory[indexPath.section].subcategory!.count ? 5.0 : -30.0
            cell.viewTopCnst.constant = CGFloat(topCnst)
            cell.viewBottomCnst.constant = CGFloat(BottomCnst)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (UserDefaults.standard.object(forKey: "userID") == nil) {
            self.showAlert(title: "Grosly", msg: "Please login to order the product") { }
            return
        }
        /*
        if indexPath.row == 0 {
            if arrCategory[indexPath.section].opened {
                arrCategory[indexPath.section].opened = false
                let section = IndexSet.init(integer: indexPath.section)
                tblViewCategory.reloadSections(section, with: .none)
            } else {
                arrCategory[indexPath.section].opened = true
                let section = IndexSet.init(integer: indexPath.section)
                tblViewCategory.reloadSections(section, with: .none)
                
            }
        } else {
            let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryProductVC") as! CategoryProductVC
            viewController.CategoryDetail = arrCategory[indexPath.section].subcategory?[indexPath.row - 1]
            self.navigationController?.pushViewController(viewController, animated: true)
        }*/
        //By PS
        let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryProductVC") as! CategoryProductVC
        viewController.selectedCatID = arrCategory[indexPath.section].catID
        viewController.isFromTopCollection = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = indexPath.row == 0 ? 90.0 : 40.0
        
        return CGFloat(height)
    }
    
    func serverHitBottomBannerList(){
        arrCategory.removeAll()
        
        WebServices().hitAPiTogetDetails(serviceType : baseUrlTest + "catee"){ (responseData) in
            let jsonData = responseData?.toJSONString1().data(using: .utf8)!
            let decoder = JSONDecoder()
            let obj = try! decoder.decode(ExpendCategory.self, from: jsonData!)
            print(jsonData)
            if obj.status == "1" {
                //   if obj.data!.count > 0 {
                if let arrFeed = obj.data {
                    _  =   arrFeed.map{
                        self.arrCategory.append($0)
                    }
                    self.tblViewCategory.reloadData()
                    self.tblViewCategory.delegate = self
                    self.tblViewCategory.dataSource = self
                }
            }
        }
    }
    
}

