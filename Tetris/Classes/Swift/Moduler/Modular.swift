


public typealias Modularable = ModularComposable & Component

public extension Component where Self : ModularComposable {
    static func tetrisStart() {
        TSTetris.shared().modular.registerModule(withClass: Self.self)
    }
}

