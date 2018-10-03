//
//  MyAppDelegate.swift
//  Tetris_Example
//
//  Created by Junren Wong on 2018/10/3.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit

class MyAppDelegate: TSBaseApplicationDelegate {
    
    override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TetrisSwiftStarter.start()
        return super.application(application, willFinishLaunchingWithOptions: launchOptions);
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

}
