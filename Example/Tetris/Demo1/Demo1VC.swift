//
//  Demo1VC.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class BSingleService: NSObject {
    
    required init(aa: Int) {
        super.init()
    }
    
    func method() {
        print("\(self)")
    }
}

protocol SwiftService {
    func swiftMethod()
}

final class SwiftServiceImpl: NSObject, IServiceable, Component, SwiftService {
    
    func swiftMethod() {
        print("lskdjf")
    }
    
    static var interface: SwiftService.Protocol? = Interface.self
    
    static var name: String?
    
    static var singleton: Bool = true
    
}

class SSSSS: NSObject {
    override init() {
        super.init()
    }
    deinit {
        print("")
    }
}

class Demo1VC: BaseVC, Routable {
    
    class var routeURLs: [URLPresentable] {
        return [LineDesc("/swift/demo1", desc: "SwiftJustRoute")]
    }
    
    override class func ts_selfIntercepter() -> Intercepter? {
        return FinalIntercepter {
            print("----- demo1 vc self intercepter -----")
            $0.doContinue()
        }
    }
    override class func ts_create(with intent: Intent) -> Intentable {
        return Self.init(id: "")
    }
    
    required init(id: String) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func ts_kvoInjector() -> NSObject? {
        return self
    }
    
    private var weak = SSSSS()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.parent as Any)
        
        let service = TSTetris.getService(by: SwiftService.self)
        service?.swiftMethod()
        
        
        print(weak)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let intent = SpecIntent<TSParams, TSParams> {
            return SpecVC()
        }
        intent.specType = TSParams.self
        intent.input(TSParams("1", number: 2, integer: 3))
        intent.displayer = PushPopDisplayer()
        intent.onSpec.subscribeNext { (ret) in
            print(ret?.value)
        }
        ts_start(intent)
    }

}

class SpecVC: BaseVC, SpecIntentable {
    
    typealias ParameterType = TSParams
    typealias SpecType = TSParams
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let param = ts_getSpecParameter()
        print(param)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ts_sendSpec(TSParams("11", number: NSNumber(value: 22), integer: 33))
    }
}
