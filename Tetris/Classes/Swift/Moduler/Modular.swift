


public typealias Modularable = ModularComposable & Component

public extension Component where Self : ModularComposable {
    public static func tetrisStart() {
        TSTetris.shared().modular.registerModule(withClass: Self.self)
    }
}

