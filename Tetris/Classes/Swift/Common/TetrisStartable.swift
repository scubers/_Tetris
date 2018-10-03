//
//  TetrisStartable.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/10/1.
//


/// Define a method that make class initializable
public protocol TetrisStartable {
    static func tetrisStart()
}


/// Define a protocol that use for auto export
public protocol Component : TetrisStartable {}


/// Tetris awaker
class TetrisAwaker {

    static let action: Void = {
        awake()
    }()

    private static func awake() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        let begin = Date.init().timeIntervalSince1970
        for index in 0 ..< typeCount {
            (types[index] as? TetrisStartable.Type)?.tetrisStart()
        }
        let end = Date().timeIntervalSince1970
        print("\(begin)")
        print("\(end)")
        print("class count: \(typeCount)")
        types.deallocate()
    }
}

@objc
public class TetrisSwiftStarter : NSObject {
    @objc public class func start() {
        TetrisAwaker.action
    }
}
