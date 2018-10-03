


public extension IComponent where Self : ModularComposable {
    public static func tetrisStart() {
        TSTetris.shared().registerModule(byClass: Self.self)
    }
}

open class AbstractModule: NSObject, ModularComposable {
    
    open var priority: ModulePriority = TSModulePriorityNormal
    
    open override func ts_didCreate() {

    }
    
    required override public init() {
        super.init()
    }
    
}

public func getService<T>(_ aProtocol: Protocol) -> T? {
    return TSTetris.shared().server.service(byProtoocl: aProtocol) as? T
}

public func getService<T>(by name: String) -> T? {
    return TSTetris.shared().server.service(byName: name) as? T
}
