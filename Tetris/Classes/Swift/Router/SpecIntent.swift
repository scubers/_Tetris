//
//  SpecIntent.swift
//  Tetris
//
//  Created by Jrwong on 2019/9/28.
//

import Foundation

public protocol SpecIntentable {
    associatedtype ParameterType: IntentSerializable
    associatedtype SpecType: IntentSerializable
}

extension SpecIntentable where Self: Intentable {
    
    public func ts_sendSpec(_ spec: SpecType) {
        ts_sourceIntent?.sendDict(spec.ts_toDict(), source: ts_viewController())
    }
    
    public func ts_getSpecParameter() -> ParameterType? {
        guard let intentParams = ts_sourceIntent?.extraParameters as? [String: Any] else {
            return nil
        }
        return ParameterType.init(fromDict: intentParams)
    }
    
}
