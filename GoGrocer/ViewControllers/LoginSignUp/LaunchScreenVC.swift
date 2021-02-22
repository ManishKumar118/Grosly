
import UIKit

class LaunchScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        if #available(iOS 13, *)
        {
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.2549019608, blue: 0.03921568627, alpha: 1)
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
            // ADD THE STATUS BAR AND SET A CUSTOM COLOR
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.2549019608, blue: 0.03921568627, alpha: 1)
            }
        }
        let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func fireTimer() {
        print("Timer fired!")
        /*
           let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
           let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        self.navigationController?.pushViewController(viewController, animated: true)
*/
          UserDefaults.standard.set(1, forKey: "1")
        if UserDefaults.standard.integer(forKey: "1") == 1 {
            let storyboard = UIStoryboard.init(name: "Base", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
         self.navigationController?.pushViewController(viewController, animated: true)
         
        } else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
        
    }
    
    //    func showAnimate()
    //    {
    //        UIView.animate(withDuration: 0, delay: 5, options: [.curveEaseIn],
    //    animations: {
    //
    //    self.loadViewIfNeeded()
    //    }, completion:{ _ in
    //   if UserDefaults.standard.integer(forKey: "1") == 1 {
    //               let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    //               let viewController = storyboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
    //            self.navigationController?.pushViewController(viewController, animated: true)
    
    //           } else {
    //               let storyboard = UIStoryboard.init(name: "Seller", bundle: nil)
    //               let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    //              self.navigationController?.pushViewController(viewController, animated: true)
    //           }
    //    })
    //
    //    }
    
    
}

