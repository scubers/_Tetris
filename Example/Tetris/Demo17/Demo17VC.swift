//
//  Demo17VC.swift
//  Tetris_Example
//
//  Created by Junren Wong on 2018/10/10.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit
// /user/info/100
// /demo17/native_map/:class_name
class Demo17Station: NSObject, Intentable, Routable {
    
    required convenience init(intent: Intent) {
        self.init()
    }
    
    static var routeURLs: [URLPresentable] {
        return ["/demo17/native_map/:className"]
    }
    
    var ts_sourceIntent: Intent? {
        didSet {
            if let name = self.ts_sourceIntent?.getString("className")
                , let classType =  NSClassFromString(name) as? UIViewController.Type {
                
                target = classType.init(nibName: nil, bundle: nil)
            }
        }
    }
    
    var target: UIViewController?
    
    func ts_viewController() -> UIViewController {
        return target!
    }
    
    class func ts_selfIntercepter() -> Intercepter? {
        return FinalIntercepter { t in
            
            guard let name = t.intent().getString("className") else {
                t.doReject(NSError(domain: "classname is nil", code: 0, userInfo: nil))
                return
            }
            
            guard let _ = NSClassFromString(name) as? UIViewController.Type else {
                t.doReject(NSError(domain: "class: \(name) is not type of UIViewController", code: 0, userInfo: nil))
                return
            }
            
            t.doContinue()
            
        }
    }
    
    
}


class Demo17VC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.darkGray
        navigationItem.title = "native_map"
    }

}
