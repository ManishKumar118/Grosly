//
//  MenuViewController.swift
//  InteractiveSlideoutMenu
//
//  Created by Robert Chen on 2/7/16.
//
//  Copyright (c) 2016 Thorn Technologies LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import SDWebImage
class MenuViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var fotterView: UIView!
    
    @IBOutlet weak var vwForMyOrder: UIView!
    @IBOutlet weak var vwForRewards: UIView!
    @IBOutlet weak var vwForWallet: UIView!
    @IBOutlet weak var vwForCart: UIView!
    //  @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var profileImg: UIImageView!
    var interactor:Interactor? = nil
    let defaultLoginData = UserDefaults.standard
    var menuActionDelegate:MenuActionDelegate? = nil
    @IBOutlet weak var constraintHeightHeader: NSLayoutConstraint!
    let  arrImage = ["ic_nav_profile","ic_nav_about","ic_nav_policy","ic_nav_share","ic_exit"]
    
    
    //let menuItems = ["My Profile", "About Us", "Terms & Privacy", "Share with Friends", "Logout"]
    // Replaced With
   //  let menuItems = ["My Profile", "About Us", "Terms & Privacy", "Logout"]
    
    var menuItems = ["Login/SignUp", "About Us", "Terms & Privacy"]
    
    var myloader = MyLoader()
    
    override func viewDidLoad() {
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName : "DrawerCell",bundle : nil), forCellReuseIdentifier: "DrawerCell")
        
        //        profileImg.layer.borderWidth = 2
        //        profileImg.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        //        profileImg.clipsToBounds = true
        //        lbl1.text = UnwarppingValue(value: fetchString(key: "name"))
        //      lbl2.text = "Welcome to Food Market"
        
        if (UserDefaults.standard.object(forKey: "userID") != nil) {
            menuItems.append("Logout")
            self.vwForMyOrder.isHidden = false
            self.vwForRewards.isHidden = false
            self.vwForWallet.isHidden = false
            self.vwForCart.isHidden = false
            constraintHeightHeader.constant = 90
        } else {
            self.vwForMyOrder.isHidden = true
            self.vwForRewards.isHidden = true
            self.vwForWallet.isHidden = true
            self.vwForCart.isHidden = true
            constraintHeightHeader.constant = 0
        }
        
    }
    
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor){
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnEditAction(_ sender: Any) {
        
        self.menuActionDelegate?.openSegue("editProfile", sender: nil)
        
    }
    
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func delay(seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        dismiss(animated: true){
            self.delay(seconds: 0.5){
                self.menuActionDelegate?.reopenMenu()
            }
        }
    }
    
    @IBAction func footerAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("djnfj")
            self.menuActionDelegate?.openSegue("order", sender: nil)
        case 2:
            self.menuActionDelegate?.openSegue("reward", sender: nil)
        case 3:
            self.menuActionDelegate?.openSegue("wallet", sender: nil)
        case 4:
            self.menuActionDelegate?.openSegue("cart", sender: nil)
           // tabBarController?.selectedIndex = 4
        default:
            print("hgh")
        }
        
    }
    
    
    @IBAction func userProfileAction(_ sender: Any) {
      //  self.menuActionDelegate?.openSegue("profile", sender: nil)
        
    }
    
}

extension MenuViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DrawerCell", for: indexPath) as! DrawerCell

        if indexPath.row == 0 {
            if (UserDefaults.standard.object(forKey: "userID") == nil) {
                 cell.lblTitle.text = menuItems[indexPath.row]
            } else {
                 cell.lblTitle.text = "Profile"
            }
        } else {
            cell.lblTitle.text = menuItems[indexPath.row]
        }
       
        cell.imgProfile.image = UIImage(named: arrImage[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

extension MenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
           // self.menuActionDelegate?.openSegue("profile", sender: nil)
            if (UserDefaults.standard.object(forKey: "userID") == nil) {
                 self.menuActionDelegate?.openSegue("logout", sender: nil)
            } else {
                self.menuActionDelegate?.openSegue("profile", sender: nil)
            }
            
        case 1:
            self.menuActionDelegate?.openSegue("about", sender: nil)
            
        case 2:
            self.menuActionDelegate?.openSegue("terms", sender: nil)
            
            /*
        case 3:
            let items = ["This app is my favorite"]
            // let items = [URL(string: "https://www.apple.com")!]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(ac, animated: true)
            print("Share")*/
        case 3:
            print("logout")
            let alertController = UIAlertController(title: ("Logout") , message: "Do you want to logout", preferredStyle: .alert)
            let Ok = UIAlertAction(title:("Ok") , style: .default) { (action) in
              //  self.dismiss(animated: true, completion: nil)
                 UserDefaults.standard.removeObject(forKey: "userID")
                 self.menuActionDelegate?.openSegue("logout", sender: nil)
                 
            }
            let cancel = UIAlertAction(title:("Cancel") , style: .cancel) { (action) in }
            alertController.addAction(Ok)
            alertController.addAction(cancel)
            self.present(alertController, animated: true) { }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
