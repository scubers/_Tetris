


public protocol IModuleComponent : IComponent {
    static var modulePriority: ModulePriority {get};
}

public extension IModuleComponent where Self : IModulable {
    public static func tetrisStart() {
        TSTetris.shared().registerModule(byClass: Self.self, priority: Self.modulePriority)
    }
}

