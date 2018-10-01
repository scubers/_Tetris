//
//  SwiftModules.swift
//  Tetris_Example
//
//  Created by 王俊仁 on 2018/10/1.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class SwiftModules: NSObject, IModuleComponent, IModulable {
    static var modulePriority: ModulePriority {
        return TSModulePriorityNormal;
    }
    required override init() {
        super.init()
    }

    func tetrisModuleInit(_ context: TSModuleContext) {
        print("\(type(of: self)) \(#function)")
    }

    func tetrisModuleSetup(_ context: TSModuleContext) {
        print("\(type(of: self)) \(#function)")
    }

    func tetrisModuleSplash(_ context: TSModuleContext) {
        print("\(#function)")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("\(#function)")

        TSTetris.shared().moduler.trigger.tetrisModuleDidTrigger!(event: 100, userInfo: nil)
    }

    func tetrisModuleDidTrigger(event: Int, userInfo: [AnyHashable : Any]? = nil) {
        print("\(#function)  event: \(event)")
    }


}
