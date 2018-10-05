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
            
            let cancel = stream.subscribeNext({ (value) in
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

public extension Observable where Element : AnyObject {
    public func toStream() -> TSStream<Element> {
        return TSStream<Element>.create({ (r) -> TSCanceller? in
            let dispose = self.subscribe(onNext: { (e) in
                r.post(e)
            }, onError: { (error) in
                r.postError(error)
            }, onCompleted: {
                r.close()
            }, onDisposed: nil)
            return TSCanceller.init(block: {
                dispose.dispose()
            })
        })
    }
}

