//
//  Demo8VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/7.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class Demo8Action: NSObject, RouteActionable {
    static var routeURLs: [URLPresentable] {
        return ["/swift/action/demo8"]
    }
    
    required override init() {
        super.init()
    }

    func getStreamBy(_ component: TreeUrlComponent) -> TSStream<AnyObject> {
        return TSStream.create({ (r) -> TSCanceller? in
            r.post("swift action success: \(component.url), param: \(component.params), fragment: \(String(describing: component.fragment))")
            r.close()
            return nil
        })
    }
}

class Demo8VC: BaseVC, Routable {

    class var routeURLs: [URLPresentable] {
        return ["/swift/demo8"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let b = UIButton(type: .custom)
        b.setTitle("click", for: .normal)
        view.addSubview(b)
        b.frame = CGRect(x: 100, y: 100, width: 100, height: 100);
        b.addTarget(self, action: #selector(Demo8VC.click), for: .touchUpInside)
    }

    @objc func click() {
        TSTetris.action(url: "/swift/action/demo8?aa=aa&bb=bb#fff")?.subscribeNext({ (r) in
            self.alert(msg: "\(String(describing: r))")
        })
    }
    


}
