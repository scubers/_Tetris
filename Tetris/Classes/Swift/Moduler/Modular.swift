


public extension IComponent where Self : ModularComposable {
    public static func tetrisStart() {
        TSTetris.shared().modular.registerModule(withClass: Self.self)
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

