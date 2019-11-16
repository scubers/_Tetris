//
//  TSIntentParam.swift
//  Tetris
//
//  Created by Jrwong on 2019/11/15.
//

import UIKit


public protocol IntentParameter {
    static func from(intent: Intent?) -> Self
}

protocol SetIntentable {
    func setIntent(_ intent: Intent?)
}

@propertyWrapper public class InjectedObject<InjectType: IntentParameter>: SetIntentable {
    
    public func setIntent(_ intent: Intent?) {
        self.intent = intent
    }
    
    public init() {}
    private var intent: Intent?
    public var wrappedValue: InjectType? {
        return InjectType.from(intent: intent)
    }
    
    public var projectedValue: InjectType?
}

@propertyWrapper public class Injected<Value>: SetIntentable {
    func setIntent(_ intent: Intent?) {
        self.intent = intent
    }
    public init(key: String) {
        self.key = key
    }
    private var intent: Intent?
    private var key: String
    public var wrappedValue: Value? {
        guard let param = intent?.extraParameters as? [String: Any] else {
            return nil
        }
        
        if let v = param[key] as? Value { return v }
        
        if Value.self == String.self {
            return intent?.getString(key) as? Value
        } else if Value.self == NSNumber.self {
            return intent?.getNumber(key) as? Value
        } else if Value.self == Int.self {
            return intent?.getNumber(key)?.intValue as? Value
        } else if Value.self == Int64.self {
            return intent?.getNumber(key)?.int64Value as? Value
        } else if Value.self == Int32.self {
            return intent?.getNumber(key)?.int32Value as? Value
        } else if Value.self == Double.self {
            return intent?.getNumber(key)?.doubleValue as? Value
        } else if Value.self == Float.self {
            return intent?.getNumber(key)?.floatValue as? Value
        } else {
            return nil
        }
    }
}

@objc public class IntentParamInjector: NSObject {
    @objc public static func inject(intent: Intent?, to object: Any) {
        Mirror(reflecting: object).children.forEach { (m) in
            if let v = m.value as? SetIntentable {
                v.setIntent(intent)
            }
        }
    }
}
