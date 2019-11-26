//
//  IntentParamInjector.swift
//  Tetris
//
//  Created by Jrwong on 2019/11/26.
//

import Foundation

protocol SetIntentable {
    func setIntent(_ intent: Intent?)
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
