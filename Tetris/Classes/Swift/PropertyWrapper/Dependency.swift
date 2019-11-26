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
