

import UIKit
import CarbonKit

class OrderVC: UIViewController, CarbonTabSwipeNavigationDelegate {
    
     @IBOutlet weak var viewMain: UIView!
    
     var itemControll = ["Pending", "Past Order"]
     var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
     var width = SCREEN_WIDTH
    
        override func viewDidLoad() {
            super.viewDidLoad()
            carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: itemControll, delegate: self)
            carbonTabSwipeNavigation.setTabBarHeight(55.0)
            carbonTabSwipeNavigation.setIndicatorHeight(6.0)
            
            carbonTabSwipeNavigation.setIndicatorColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
            carbonTabSwipeNavigation.setNormalColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), font: UIFont(name: "Helvetica Neue", size: 22)!)
            carbonTabSwipeNavigation.setSelectedColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), font: UIFont(name: "Helvetica Neue", size: 22)!)
            
            self.carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(horizontalCenter, forSegmentAt: 0)
            self.carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(horizontalCenter, forSegmentAt: 1)
            carbonTabSwipeNavigation.carbonSegmentedControl?.backgroundColor = #colorLiteral(red: 0.1011154428, green: 0.2531051338, blue: 0.03805134445, alpha: 1)
            carbonTabSwipeNavigation.insert(intoRootViewController: self, andTargetView: viewMain)
            carbonTabSwipeNavigation.carbonSegmentedControl?.indicator.roundCorner()
            
            // Do any additional setup after loading the view.
        }
        
        func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
               guard let storyboard = storyboard else { return UIViewController() }
                   if index == 0 {
                       return storyboard.instantiateViewController(withIdentifier: "PendingVC")
                   }
                       return storyboard.instantiateViewController(withIdentifier: "PastOrderVC")
               
           }
          
    @IBAction func backAction(_ sender: Any) {
           
           self.navigationController?.popViewController(animated: true)
           
       }
    
    

    }

