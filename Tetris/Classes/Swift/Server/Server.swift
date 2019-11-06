


/// Extent Serviceable in swift that provide some
/// meta info to bind a service
public protocol IServiceable : Serviceable {
    associatedtype Interface
    static var interface: Interface.Type? { get }
    static var name: String? { get }
    static var singleton: Bool { get }
}

// MARK: - Extent Component for Iserviceable
public extension Component where Self : IServiceable {
    static func tetrisStart() {
        if let interface = self.interface {
            TSTetris.shared().server.bindService(byName: "\(interface)", class: Self.self, singleton: self.singleton)
        } else if let name = self.name {
            TSTetris.shared().server.bindService(byName: name, class: Self.self, singleton: self.singleton)
        }
    }
}

public typealias ServiceComponent = IServiceable & Component

extension TSTetris {
    public static func getService<T>(by name: String) -> T? {
        return TSTetris.shared().server.service(byName: name) as? T
    }
    
    public static func getService<T>(by type: T.Type) -> T? {
        return TSTetris.shared().server.service(byName: "\(type)") as? T
    }
    
    public static func registe<T: Noticable>(_ notice: T.Type, listener: LifeEndable, handler: @escaping (T) -> Void) {
        BroadCast.shared.registe(for: notice, listener: listener) { (info) in
            if let notice = info as? T {
                handler(notice)
            } else {
                TSLogger.logMsg("Cannot convert \(info) to \(notice)")
            }
        }
    }
    
    public static func post<T: Noticable>(_ notice: T) {
        BroadCast.shared.post(notice)
    }
}

extension WeakSingleton {
    public static func create<T: Destroyable>(by type: T.Type) -> T {
        return WeakSingleton.shared().create(withType: type) as! T
    }
    
    public static func create<T: Destroyable>(by type: T.Type, from lifeCycle: Destroyable?) -> T {
        if let lc = lifeCycle {
            return WeakSingleton.shared().create(withType: type, lifeCycle: lc) as! T
        }
        return create(by: type)
    }
}
