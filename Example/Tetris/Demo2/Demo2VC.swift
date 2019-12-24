//
//  Demo2VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class Demo2VC: BaseVC, Routable {

    static var routeURLs: [URLPresentable] {
        return ["/swift/demo2/demo2"]
    }

    struct Param: IntentParameter {
        var name: String?
        var number: Int = 0
        static func from(intent: Intent?) -> Self {
            return Param(name: intent?.getString("name"),
                         number: intent?.getNumber("number")?.intValue ?? 0)
        }
    }
    
    @InjectedObject()
    var param: Param?
    
    @Injected(key: "name")
    var myName: String?
    @Injected(key: "number")
    var myNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("""
        myName: \(myName)
        myNumber: \(myNumber)
        """)
        alert(msg: """
            fragment: \(String(describing: ts_sourceIntent?.urlComponent?.fragment))
            params: \(String(describing: ts_sourceIntent?.urlComponent?.params))
            name: \(String(describing: param?.name))
            number: \(String(describing: param?.number))
            """)
    }

}
