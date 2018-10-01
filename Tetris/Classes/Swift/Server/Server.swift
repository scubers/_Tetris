


public protocol IServiceComponent : IComponent, TSServiceExportable {
    static var servicePrtocol : Protocol? {get}
    static var serviceName : String? {get}
    static var singleton: Bool {get}
}

public extension IServiceComponent where Self : TSServiceExportable {
    public static func tetrisStart() {
        if let pr = self.servicePrtocol {
            TSTetris.shared().serviceMgr.bindService(by: pr, class: Self.self, singleton: self.singleton)
        } else if let name = self.serviceName {
            TSTetris.shared().serviceMgr.bindService(byName: name, class: Self.self, singleton: self.singleton)
        }
    }
}

