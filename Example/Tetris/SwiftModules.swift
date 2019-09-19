//
//  SwiftModules.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit
import RxSwift


class SwiftModules1: NSObject, Modularable {
    
    required override init() {
        super.init()
    }
    
    var priority: ModulePriority = TSModulePriorityNormal + 2000
    
    func tetrisModuleInit(_ context: ModuleContext) {
        print("\(type(of: self)) \(#function)")
        
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func tetrisModuleDidTrigger(event: Int, userInfo: [AnyHashable : Any]? = nil) {
        print("\(type(of: self)) \(#function)")
    }
}

class SwiftModules2: NSObject, Modularable {
    required override init() {
        super.init()
    }
    var priority: ModulePriority = TSModulePriorityHigh  + 20000
    func tetrisModuleInit(_ context: ModuleContext) {
        print("\(type(of: self)) \(#function)")
    }

}

class SwiftModules3: NSObject, Modularable {
    required override init() {
        super.init()
    }
    var priority: ModulePriority = TSModulePriorityLow + 20000
    func tetrisModuleInit(_ context: ModuleContext) {
        print("\(type(of: self)) \(#function)")
    }
}

class SwiftModules4: NSObject, Modularable {
    required override init() {
        super.init()
    }
    var priority: ModulePriority = TSModulePriorityNormal  + 20000
    func tetrisModuleInit(_ context: ModuleContext) {
        print("\(type(of: self)) \(#function)")
    }
}

@objc
public protocol TestProtocolA {
    func methodA()
}




class Services : NSObject, IServiceable, Component, TestProtocolA {
    
    typealias Interface = TestProtocolA
    
    static var interface: TestProtocolA.Protocol? = TestProtocolA.self
    
    required override init() {
        super.init()
    }
    
    static var name: String?
    
    static var singleton: Bool = false
    
    
    func methodA() {
        print("--swift servcie---")
    }
    
    
    
}


class MyAction: NSObject, RouteActionable {
    
    required override init() {
        super.init()
    }
    
    class var routeURLs: [URLPresentable] {
        return ["/swift/actionDemo?"]
    }
    
    func getStreamBy(_ component: TreeUrlComponent) -> TSStream<AnyObject> {
        return
            Observable<AnyObject>
                .just(100 as AnyObject)
                .toStream()
                .onNext({ (_) in
                    
                })
    }
    
    func test() {
        
        _ = Observable<AnyObject>
            .by(stream: getStreamBy(TreeUrlComponent()))
            .map({ _ in return 100})
            .do(onNext: { (next) in
                
            })
            .do(onError: { error in
                
            })
            .subscribe()
        
    }
    
    
    
}
