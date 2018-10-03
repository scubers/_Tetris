


public extension IComponent where Self : IModulable {
    public static func tetrisStart() {
        TSTetris.shared().registerModule(byClass: Self.self)
    }
}

open class AbstractModule: NSObject, IModulable {
    
    open var priority: ModulePriority = TSModulePriorityNormal
    
    open override func ts_didCreate() {

    }
    
    required override public init() {
        super.init()
    }
    
}

