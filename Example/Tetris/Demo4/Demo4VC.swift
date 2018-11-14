//
//  Demo4VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class Demo4Inter: IntercepterAdapter, Component {

    override func matchUrlPatterns() -> [String]? {
        return ["^((\\w+)://)?(\\w+)?/swift/demo4\\??.*$"]
    }

    override func doAdjudgement(_ judger: IntercepterJudger) {
        print("swift Demo4: intercepter continued~~")
        judger.doContinue()
    }
}

class Demo4VC: BaseVC, Routable {
    static var routeURLs: [URLPresentable] {
        return ["/swift/demo4"]
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
