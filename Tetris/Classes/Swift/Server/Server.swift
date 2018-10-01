


public protocol IServiceComponent : IComponent, ServiceExportable {
    static var servicePrtocol : Protocol? {get}
    static var serviceName : String? {get}
    static var singleton: Bool {get}
}

public extension IServiceComponent where Self : ServiceExportable {
    public static func tetrisStart() {
        if let pr = self.servicePrtocol {
            TSTetris.shared().server.bindService(by: pr, class: Self.self, singleton: self.singleton)
        } else if let name = self.serviceName {
            TSTetris.shared().server.bindService(byName: name, class: Self.self, singleton: self.singleton)
        }
    }
}

