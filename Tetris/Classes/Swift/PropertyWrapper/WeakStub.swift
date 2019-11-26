//
//  WeakStub.swift
//  Tetris
//
//  Created by Jrwong on 2019/11/26.
//

import Foundation

/// weak singleton
@propertyWrapper public class WeakStub<ValueType: Destroyable> {
    
    public init(_ holder: Destroyable? = nil) {
        self.holder = holder
    }
    private var holder: Destroyable?
    private lazy var _value: ValueType = {
        if let holder = self.holder {
            return WeakSingleton.create(by: ValueType.self, from: holder)
        }
        return WeakSingleton.create(by: ValueType.self)
    }()
    public var wrappedValue: ValueType? { _value }
}
