

/// Define a protocol that instance can present as a url
public protocol URLPresentable {
    func toURL() throws -> URL
}

/// Define a protocol that instance can provide a list of urls
public protocol URLRoutable {
    static var routeURLs : [URLPresentable] {get}
}


// MARK: - Extent url conforms to URLPresentable
extension URL : URLPresentable {
    public func toURL() throws -> URL {
        return self
    }
}

// MARK: - Extent String conforms to URLPresentable
extension String : URLPresentable {
    public func toURL() throws -> URL {
        return URL.init(string: self)!
    }
}

// MARK: - Extent NSString conforms to URLPresentable
extension NSString : URLPresentable {
    public func toURL() throws -> URL {
        return URL.init(string: self as String)!
    }
}


/// Define a Protocol that can auto export for routable
public typealias Routable = (Component & URLRoutable)

public extension Component where Self : URLRoutable, Self : Intentable {
    public static func tetrisStart() {
        self.routeURLs.forEach { (url) in
            try! TSTetris.shared().router.bindUrl(url.toURL().absoluteString, viewController: Self.self)
        }
    }
}

public extension Component where Self : Intercepter {
    public static func tetrisStart() {
        TSTetris.shared().router.intercepterMgr.add(intercepter: self.ts_create())
    }
}

public typealias RouteActionable = (Component & RouteActioner & URLRoutable)

public extension Component where Self : RouteActioner, Self : URLRoutable {
    public static func tetrisStart() {
        TSTetris.shared().router.bindUrl(try! self.routeURLs.first!.toURL().absoluteString,
                                         toRouteAction: self.ts_create())
    }
}

// MARK: - public methods


/// Convenience method start a intent with VC
///
/// - Parameters:
///   - intent: intent
///   - source: ViewController
public func start(intent: Intent, source: UIViewController) {
    TSTetris.shared().router.prepare(intent, source: source, complete: nil)
}


/// Convenience method prepare a intent
///
/// - Parameters:
///   - intent: intent
///   - source: source
///   - complete: callback
/// - Returns: TSStream<RouteResult>
public func prepare(intent: Intent, source: UIViewController? = nil, complete: (()->Void)?) -> TSStream<RouteResult> {
    return TSTetris.shared().router.prepare(intent, source: source, complete: complete)
}


/// Convenience method to bind an action to url
///
/// - Parameters:
///   - url: url
///   - action: action
public func bind(url: String, to action: @escaping (TreeUrlComponent) -> TSStream<AnyObject>) {
    TSTetris.shared().router.bindUrl(url, toAction: action)
}


/// Convenience method to execute an action with url
///
/// - Parameter url: url
/// - Parameter params: params
/// - Returns: TSStream
public func action(url: String, params: [AnyHashable: Any]? = nil) -> TSStream<AnyObject>? {
    return TSTetris.shared().router.action(byUrl: url, params: params)
}
