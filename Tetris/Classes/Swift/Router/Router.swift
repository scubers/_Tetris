
/// Define a protocol that instance can present as a url
public protocol URLPresentable {
    func to_tsUrl() -> TSURLPresentable
    func ts_description() -> String
}

/// Define a protocol that instance can provide a list of urls
public protocol URLRoutable {
    static var routeURLs : [URLPresentable] {get}
}

// MARK: - Extent url conforms to URLPresentable
extension URL : URLPresentable {
    public func to_tsUrl() -> TSURLPresentable {
        return NSURL(string: self.absoluteString)!
    }
    public func ts_description() -> String {
        return description
    }
}

// MARK: - Extent String conforms to URLPresentable
extension String : URLPresentable {
    public func to_tsUrl() -> TSURLPresentable {
        return NSString(string: self)
    }
    
    public func ts_description() -> String {
        return description
    }
}

public struct LineDesc: URLPresentable {
    public let url: TSURLPresentable
    public let desc: String
    
    public init(_ line: String, desc: String = "") {
        url = line.to_tsUrl()
        self.desc = desc
    }
    
    public init(_ line: TSURLPresentable, desc: String = "") {
        url = line
        self.desc = desc
    }
    
    public func to_tsUrl() -> TSURLPresentable {
        return url
    }
    
    public func ts_description() -> String {
        return desc
    }
}

/// Define a Protocol that can auto export for routable
public typealias Routable = (Component & URLRoutable)

public extension Component where Self : URLRoutable, Self : Intentable {
    static func tetrisStart() {
        self.routeURLs.forEach { (url) in
            TSTetris.shared().router.bindLine(Line(url: url.to_tsUrl(), desc: url.ts_description(), class: Self.self))
        }
    }
}

public extension Component where Self : Intercepter {
    static func tetrisStart() {
        TSTetris.shared().router.intercepterMgr.add(self)
    }
}

public typealias RouteActionable = (Component & RouteActioner & URLRoutable)

public extension Component where Self : RouteActioner, Self : URLRoutable {
    static func tetrisStart() {
        TSTetris.shared().router.bindUrl(self.routeURLs.first!.to_tsUrl(),
                                         toRouteAction: self.init())
    }
}

// MARK: - public methods

extension TSTetris {
    /// Convenience method start a intent with VC
    ///
    /// - Parameters:
    ///   - intent: intent
    ///   - source: ViewController
    public static func start(intent: Intent, source: UIViewController) {
        _ = TSTetris.shared().router.prepare(intent, source: source, complete: nil).subscribe()
    }


    /// Convenience method prepare a intent
    ///
    /// - Parameters:
    ///   - intent: intent
    ///   - source: source
    ///   - complete: callback
    /// - Returns: TSStream<RouteResult>
    public static func prepare(intent: Intent, source: UIViewController? = nil, complete: (() -> Void)? = nil) -> TSStream<RouteResult> {
        return TSTetris.shared().router.prepare(intent, source: source, complete: complete)
    }


    /// Convenience method to bind an action to url
    ///
    /// - Parameters:
    ///   - url: url
    ///   - action: action
    public static func bind(url: URLPresentable, to action: @escaping (TreeUrlComponent) -> TSStream<AnyObject>) {
        TSTetris.shared().router.bindUrl(url.to_tsUrl(), toAction: action)
    }


    /// Convenience method to execute an action with url
    ///
    /// - Parameter url: url
    /// - Parameter params: params
    /// - Returns: TSStream
    public static func action(url: URLPresentable, params: [AnyHashable: Any]? = nil) -> TSStream<AnyObject>? {
        return TSTetris.shared().router.action(byUrl: url.to_tsUrl(), params: params)
    }
}
