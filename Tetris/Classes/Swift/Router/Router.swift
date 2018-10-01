

public protocol URLPresentable {
    func toURL() throws -> URL
}

public protocol URLRoutable {

    static var routeURLs : [URLPresentable] {get}

}

extension URL : URLPresentable {
    public func toURL() throws -> URL {
        return self
    }
}

extension String : URLPresentable {
    public func toURL() throws -> URL {
        return URL.init(string: self)!
    }
}

extension NSString : URLPresentable {
    public func toURL() throws -> URL {
        return URL.init(string: self as String)!
    }
}


public typealias IRouterComponent = (IComponent & URLRoutable)

public extension IComponent where Self : URLRoutable, Self : TSIntentable {
    public static func tetrisStart() {
        self.routeURLs.forEach { (url) in
            try! TSTetris.shared().router.bindUrl(url.toURL().absoluteString, viewController: Self.self)
        }
    }
}


public typealias IIntercepterComponent = (IComponent)

public extension IComponent where Self : TSIntercepterProtocol {
    public static func tetrisStart() {
        TSTetris.shared().router.intercepterMgr.addIntercepter(Self.init())
    }
}


public protocol IAction {
    static var streamAction: (TSTreeUrlComponent) -> TSStream<AnyObject> { get }
}

public typealias IActionComponent = (IComponent & IAction & URLRoutable)

public extension IComponent where Self : IAction, Self : URLRoutable {
    public static func tetrisStart() {
        TSTetris.shared().router.bindUrl(try! self.routeURLs.first!.toURL().absoluteString,
                                         toAction: self.streamAction)
    }
}
