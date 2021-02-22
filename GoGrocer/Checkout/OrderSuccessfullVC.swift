
import UIKit

class OrderSuccessfullVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shopAction(_ sender: Any) {
        popToHome()
        tabBarController?.selectedIndex = 0
        
    }
    
    
    func popToHome() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        for vc in viewControllers{
            if vc.isKind(of:TabBarVC.self){
                self.navigationController!.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
}
