//
//  Demo3VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class Demo3Inter: IntercepterAdapter, Component {
    required init() {
        super.init()
        priority = TSIntercepterPriorityNormal
    }

    override func matchUrlPatterns() -> [String]? {
        return ["^((\\w+)://)?(\\w+)?/swift/demo3\\??.*$"]
    }

    override func doAdjudgement(_ judger: IntercepterJudger) {
        let msg = "Reject by Class: \(type(of: self))"
        print(msg)
        judger.doReject(NSError.init(domain: msg, code: 10, userInfo: nil))
    }
}

class Demo3VC: BaseVC, Routable {
    class var routeURLs: [URLPresentable] {
        return ["/swift/demo3"]
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        assert(false, "can not enter this VC")
    }


}
