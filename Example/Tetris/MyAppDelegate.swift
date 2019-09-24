//
//  MyAppDelegate.swift
//  Tetris_Example
//
//  Created by Junren Wong on 2018/10/3.
//  Copyright © 2018 wangjunren. All rights reserved.
//

import UIKit
import RxSwift

class MyAppDelegate: TSBaseApplicationDelegate {
    
    override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        TetrisSwiftStarter.start()
        return super.application(application, willFinishLaunchingWithOptions: launchOptions);
    }
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        var swiftDemo = true
        
        let p = PublishSubject<Bool>()
        
        TSTetris.shared().router.subscribeDriven(byUrl: "/changeDemo".to_tsUrl()) { (comp) in
            swiftDemo = !swiftDemo
            p.onNext(swiftDemo)
        }
        
        _ =
            p
            .flatMap({isSwift -> Observable<RouteResult> in
                if isSwift {
                    return Observable<RouteResult>.by(stream: TSTetris.prepare(intent: Intent.pushPop(byUrl: "/swift/menu")))
                }
                return Observable<RouteResult>.by(stream: TSTetris.prepare(intent: Intent.pushPop(byUrl: "/menu")))
            })
            .subscribe({ event in
                switch event {
                case .next(let e):
                    self.window?.rootViewController = UINavigationController.init(rootViewController: e.viewControllable!.ts_viewController())
                default:break
                }
            })
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        p.onNext(true)
        
        TSTetris.shared().router.action(byUrl: "/swift/actionDemo".to_tsUrl())?.subscribeNext({ (_) in
            
        })
        
        TSTetris.shared().router.action(byUrl: "/oc/actionDemo".to_tsUrl())?.subscribeNext({ (_) in
            
        })
        
        let service: TestProtocolA? = TSTetris.getService(by: TestProtocolA.self)
        service?.methodA()
        
        window?.makeKeyAndVisible()

        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

}
