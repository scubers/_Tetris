//
//  BroadCast.swift
//  Tetris
//
//  Created by Jrwong on 2019/11/6.
//

import UIKit

@objc(TSNoticable) public protocol Noticable {
    
}

@objc(TSLifeEndable) public protocol LifeEndable {
    func onLifeEnding(_ action: @escaping () -> Void)
}

@objc(TSBroadCast)
public class BroadCast: NSObject {
    
    @objc public static let shared = BroadCast()
    private static let broadCastKey = "broadCastKey"
    
    @objc public func registe(notice: Noticable.Type, listener: LifeEndable, handler: @escaping (Noticable) -> Void) {
        let name = NSNotification.Name(getNoticeName(type: notice))
        let obj = NotificationCenter.default.addObserver(forName: name, object: self, queue: .main) { (n) in
            if let info = n.userInfo?[BroadCast.broadCastKey] as? Noticable {
                handler(info)
            }
        }
        listener.onLifeEnding {
            NotificationCenter.default.removeObserver(obj)
        }
    }
    
    @objc public func post(_ notice: Noticable) {
        NotificationCenter.default.post(name: getNotification(type: type(of: notice)),
                                        object: self,
                                        userInfo: [BroadCast.broadCastKey: notice])
    }
    
}

private extension BroadCast {
    private func getNoticeName(type: Noticable.Type) -> String {
        return "TSBroadCastType_\(NSStringFromClass(type))"
    }
    
    private func getNotification(type: Noticable.Type) -> Notification.Name {
        return Notification.Name(rawValue: getNoticeName(type: type))
    }
}


// MARK: - NSObject unbinder impl
extension NSObject: LifeEndable {
    
    public func onLifeEnding(_ action: @escaping () -> Void) {
        ts_lifeEnderContainer.setUnbinder(_Action(action: action), for: UUID().description)
    }
    
    private static var tetris_lifeEnderContainerKey = "tsLifeEnderKey"
    private var ts_lifeEnderContainer: _EnderContainer {
        var container = objc_getAssociatedObject(self, &NSObject.tetris_lifeEnderContainerKey)
        if container == nil {
            container = _EnderContainer(name: NSStringFromClass(type(of: self)), address: "")
            objc_setAssociatedObject(self, &NSObject.tetris_lifeEnderContainerKey, container, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        return container as! _EnderContainer
    }
    
    private struct _Action {
        var action: () -> Void
    }
    
    private class _EnderContainer: NSObject {
        private var ender = [String: _Action]()
        private var name: String = ""
        private var address: String = ""
        convenience init(name: String, address: String) {
            self.init()
            self.name = name
            self.address = address
        }
        
        func setUnbinder(_ unbinder: _Action, for key: String) {
            let old = ender[key]
            old?.action()
            ender[key] = unbinder
        }
        
        deinit {
            ender.forEach { (_, unbinder) in
                unbinder.action()
            }
        }
    }
}
