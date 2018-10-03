//
//  Demo5VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class Demo5Inter: IntercepterAdapter, Component {
    required override init() {
        super.init()
    }

    override func matchUrlPatterns() -> [String]? {
        return ["/swift/demo5\\??.*"]
    }

    override func doAdjudgement(_ judger: IntercepterJudger) {
        print("swift Demo5 switch intercepter!!")
        let intent = Intent.pushPop(byUrl: "/swift/interceptered/demo5#intercepted")!
        intent.displayer = judger.intent().displayer
        judger.doSwitch(intent)
    }

}

class Demo5VC: BaseVC, Routable {


    class var routeURLs: [URLPresentable] {
        return ["/swift/demo5", "/swift/interceptered/demo5"]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let f = ts_sourceIntent?.urlComponent?.fragment, f.count > 0 {
            alert(msg: f)
        }
    }

}
