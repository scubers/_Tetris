//
//  Demo1VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit


class Demo1VC: BaseVC, Routable {
    
    class var routeURLs: [URLPresentable] {
        return [LineDesc("/swift/demo1", desc: "SwiftJustRoute")]
    }
    
    required convenience init(intent: Intent) {
        self.init()
    }
    
    override class func ts_selfIntercepter() -> Intercepter? {
        return FinalIntercepter {
            print("----- demo1 vc self intercepter -----")
            $0.doContinue()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.parent as Any)
        if let parent = self.parent, let vm = TSViewModelFactory.shared.createViewModel(DemoViewModel.self, lifeController: parent) as? DemoViewModel {
            vm.demo()
        }
    }

}

class OOO: NSObject {
    required convenience init(value: Int) {
        self.init()
    }
}


class DemoViewModel: NSObject, ViewModelable {
    required override init() {
        super.init()
    }
    
    func demo() {
        print("view model function exectuted: \(self)")
    }
}
