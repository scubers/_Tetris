//
//  Stream.swift
//  Tetris
//
//  Created by Junren Wong on 2018/10/3.
//

import Foundation
import RxSwift

extension TSCanceller : Disposable {
    public func dispose() {
        cancel()
    }
}

public extension Observable {

    public class func by<Value>(stream: TSStream<Value>) -> Observable<Value> {
        return Observable<Value>.create({ (o) -> Disposable in
            
            let cancel = stream.subscribe({ (value) in
                o.onNext(value!)
            }, error: { (error) in
                o.onError(error)
            }, complete: {
                o.onCompleted()
            })
            return cancel
        })
    }
}


