//
//  CancelOrderOption.swift
//  GoGrocer
//
//  Created by Pooja on 06/07/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import IBAnimatable

var isCancelOption = Bool()

class CancelOrderOption: UIViewController {
    
    @IBOutlet weak var viewCancelOption: AnimatableView!
    @IBOutlet weak var viewCanceled: AnimatableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        if isCancelOption {
            self.viewCanceled.isHidden = true
            self.viewCancelOption.isHidden = false
        } else {
           self.viewCanceled.isHidden = false
           self.viewCancelOption.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func MinAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func noAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func yesAction(_ sender: Any) {
        self.pushController(storyBord: "Base", viewController: "CoupenVC")
    }
    
    @IBAction func okAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func backTwo() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        for vc in viewControllers{
            if vc.isKind(of:HomeVC.self) {
                self.navigationController!.popToViewController(vc, animated: true)
                break
            }
        }
    }
}
