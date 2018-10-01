


public protocol IModuleComponent : IComponent {
    static var modulePriority: TSModulePriority {get};
}

public extension IModuleComponent where Self : TSTetrisModulable {
    public static func tetrisStart() {
        TSTetris.shared().registerModule(byClass: Self.self, priority: Self.modulePriority)
    }
}

