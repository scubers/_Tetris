//
//  SwiftModules.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class SwiftBaseModule: AbstractModule {
    func tetrisModuleInit(_ context: TSModuleContext) {
        print("\(type(of: self)) \(#function)")
    }
    
    lazy var service: TestProtocolA? = Tetris.getService(TestProtocolA.self)
    
    func tetrisModuleSetup(_ context: TSModuleContext) {
        print("\(type(of: self)) \(#function)")
    }
    
    func tetrisModuleSplash(_ context: TSModuleContext) {
        print("\(#function)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print("\(#function)")
        
        TSTetris.shared().modular.trigger.tetrisModuleDidTrigger!(event: 100, userInfo: nil)
    }
    
    func tetrisModuleDidTrigger(event: Int, userInfo: [AnyHashable : Any]? = nil) {
        print("\(#function)  event: \(event)")
    }
}

class SwiftModules1: SwiftBaseModule, Component {
    open override func ts_didCreate() {
        priority = TSModulePriorityNormal + 20000
    }
}
class SwiftModules2: SwiftBaseModule, Component {
    open override func ts_didCreate() {
        priority = TSModulePriorityHigh  + 20000
    }
}
class SwiftModules3: SwiftBaseModule, Component {
    open override func ts_didCreate() {
        priority = TSModulePriorityLow + 20000
    }
}
class SwiftModules4: SwiftBaseModule, Component {
    open override func ts_didCreate() {
        priority = TSModulePriorityNormal  + 20000
    }
}

@objc
public protocol TestProtocolA {
    func methodA()
}




class Services : NSObject, IServiceable, Component, TestProtocolA {
    
    static var interface: Protocol? = TestProtocolA.self
    
    static var name: String?
    
    static var singleton: Bool = false
    
    
    func methodA() {
        print("--swift servcie---")
    }
    
    
}


class MyAction: NSObject, RouteActionable {
    
    class var routeURLs: [URLPresentable] {
        return ["/swift/actionDemo?"]
    }
    
    func getStreamBy(_ component: TreeUrlComponent) -> TSStream<AnyObject> {
        return TSStream<AnyObject>.create({ (r) -> TSCanceller? in
            r.post(100)
            r.close()
            return nil
        })
    }
    
    
    
}
