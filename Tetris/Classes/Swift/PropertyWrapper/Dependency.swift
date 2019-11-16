//
//  TSInjected.swift
//  Tetris
//
//  Created by Jrwong on 2019/11/14.
//

/// dependency injection
@propertyWrapper public class Dependency<ValueType> {
    
    public init(name: String? = nil) {
        _name = name
    }
    private var _name: String?
    private lazy var _value: ValueType? = {
        if let name = self._name {
            return TSTetris.getService(by: name)
        }
        return TSTetris.getService(by: ValueType.self)
    }()
    public var wrappedValue: ValueType? { _value }
}

/// weak singleton
@propertyWrapper public class SingletonStub<ValueType: Destroyable> {
    
    public init(_ holder: Destroyable?) {
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
