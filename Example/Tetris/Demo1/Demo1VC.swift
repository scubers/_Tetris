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
        return ["/swift/demo1"]
    }
    
    class func ts_finalIntercepter() -> Intercepter? {
        return FinalIntercepter.init { $0.doContinue() }
    }

}
