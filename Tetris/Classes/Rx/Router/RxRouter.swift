//
//  RxRouter.swift
//  Tetris
//
//  Created by Junren Wong on 2018/10/16.
//

import RxSwift

public func prepare(intent: Intent, source: UIViewController? = nil, complete: (()->Void)? = nil) -> Observable<RouteResult> {
    return Observable<RouteResult>.by(stream: TSTetris.shared().router.prepare(intent, source: source, complete: complete))
}
