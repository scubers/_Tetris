//
//  Demo16VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit


class Demo16VC: BaseVC, Routable {

    class var routeURLs: [URLPresentable] {
        return ["/demo16"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn = UIButton(type: .custom)
        btn.setTitle("click", for: .normal)
        view.addSubview(btn)
        btn.center = view.center
        btn.sizeToFit()
        btn.addTarget(self, action: #selector(Demo16VC.click), for: .touchUpInside)
    }

    @objc func click() {
        let intent = Intent.pushPop(byUrl: "")
        intent.factory = { [weak self] in
            let vc = BaseVC()
            vc.view.backgroundColor = UIColor.darkGray
            print("catch self \(String(describing: self))")
            return vc
        }
        intent.onDestroy.subscribeNext { (_) in
            
        }
        ts_start(intent)
    }

}
