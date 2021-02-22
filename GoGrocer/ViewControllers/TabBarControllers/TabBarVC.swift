

import UIKit
@available(iOS 13.0, *)
let APPDELEGATE = UIApplication.shared.delegate! as! AppDelegate

class TabBarVC: UITabBarController {
    
    var isIpad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(1, forKey: "1")
        self.navigationController?.navigationBar.isHidden = true
    //    self.tabBar.unselectedItemTintColor = UIColor.black
        self.navigationItem.hidesBackButton = true
        self.selectedIndex = 0
        if #available(iOS 13.0, *) {
            APPDELEGATE.tabBar = self
        } else {
            
        }
        
    }
}

extension TabBarVC : UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("the last selected index is : \(selectedIndex)")
        
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
            
        print("testing \(viewController)")
        return true
    }
    
}
