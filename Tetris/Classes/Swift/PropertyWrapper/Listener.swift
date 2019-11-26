//
//  BroadCaster.swift
//  Tetris
//
//  Created by Jrwong on 2019/11/26.
//

import Foundation

/// 广播注解
@propertyWrapper public class Listener<Notice: Noticable> {
    
    public typealias N = Notice
    
    public init() {}
    
    private var endings = [() -> Void]()
    
    private var channel = Channel()
    
    public var wrappedValue: Listener<Notice> { self }
    
    public func post(_ notice: N) {
        channel.post(notice: notice)
    }
    
    public func listen(_ action: @escaping (N) -> Void) {
        channel.listen(type: Notice.self) { (n) in
            if let n = n as? N {
                action(n)
            }
        }
    }
    
}
