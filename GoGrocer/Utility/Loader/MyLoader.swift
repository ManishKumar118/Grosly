//
//  MyLoader.swift
//  demoApp
//
//  Created by IBC Mobile on 9/20/17.
//  Copyright © 2017 IBC Mobile. All rights reserved.
//
import UIKit

class MyLoader: NSObject {
    let loader = Loader(nibName : "Loader" ,bundle:nil)
    
    func showLoader (controller : UIViewController)
    {
        loader.view.frame = CGRect(x: 0, y: 0, width: controller.view.frame.size.width, height: controller.view.frame.size.height)
        controller.view.addSubview(loader.view)
        loader.view.bringSubviewToFront(controller.view)
        loader.view.isHidden = false
    }
    
    func showLoaderInPopUp (view : UIView)
    {
        loader.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        view.addSubview(loader.view)
        loader.view.isHidden = false
    }
    

    func removeLoader(controller : UIViewController){
        loader.view.isHidden = true
        print(loader.view)
    }
    
    
 
    
}
