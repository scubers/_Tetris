


public protocol IServiceable : Serviceable {
    static var interface : Protocol? {get}
    static var name : String? {get}
    static var singleton: Bool {get}
}

public extension IComponent where Self : IServiceable {
    public static func tetrisStart() {
        if let pr = self.interface {
            TSTetris.shared().server.bindService(by: pr, class: Self.self, singleton: self.singleton)
        } else if let name = self.name {
            TSTetris.shared().server.bindService(byName: name, class: Self.self, singleton: self.singleton)
        }
    }
}

public func getService<T>(_ aProtocol: Protocol) -> T? {
    return TSTetris.shared().server.service(byProtoocl: aProtocol) as? T
}

public func getService<T>(by name: String) -> T? {
    return TSTetris.shared().server.service(byName: name) as? T
}
