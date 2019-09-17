


/// Extent Serviceable in swift that provide some
/// meta info to bind a service
public protocol IServiceable : Serviceable {
    static var interface : Protocol? {get}
    static var name : String? {get}
    static var singleton: Bool {get}
}


// MARK: - Extent Component for Iserviceable
public extension Component where Self : IServiceable {
    static func tetrisStart() {
        if let pr = self.interface {
            TSTetris.shared().server.bindService(by: pr, class: Self.self, singleton: self.singleton)
        } else if let name = self.name {
            TSTetris.shared().server.bindService(byName: name, class: Self.self, singleton: self.singleton)
        }
    }
}


/// Global get service method
///
/// - Parameter aProtocol: protocol
/// - Returns: instance
public func getService<T>(_ aProtocol: Protocol) -> T? {
    return TSTetris.shared().server.service(byProtoocl: aProtocol) as? T
}

/// Global get service method
///
/// - Parameter name: name
/// - Returns: instance
public func getService<T>(by name: String) -> T? {
    return TSTetris.shared().server.service(byName: name) as? T
}

extension WeakSingleton {
    public static func create<T: Destroyable>(by type: T.Type) -> T {
        return WeakSingleton.shared().create(withType: type) as! T
    }
}
