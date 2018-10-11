//
//  TetrisStartable.swift
//  Tetris
//
//  Created by 王俊仁 on 2018/10/1.
//


/// Define a method that make class initializable
public protocol TetrisStartable {
    static func tetrisStart()
}


/// Define a protocol that use for auto export
public protocol Component : TetrisStartable {}


@objc
public class TetrisSwiftStarter : NSObject {
    @objc public class func start() {
        
        let path = getDefaultPath()
        
        let begin = Date.init().timeIntervalSince1970
        if FileManager.default.fileExists(atPath: path) && construct(path: path) {
            
        } else {
            _ = onlyAction
        }
        let end = Date().timeIntervalSince1970
        print("\(begin)")
        print("\(end)")
    }
    
    
    static var onlyAction: Void = {
        let classes = starAwake()
        do {
            let data = try JSONEncoder().encode(classes)
            let path = getDefaultPath()
            try data.write(to: URL.init(fileURLWithPath: path))
        } catch {
            print(error)
        }
        
    }()
    
    class func getDefaultPath() -> String {
//        return "/Users/j/Desktop/aaa.json"
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        var docDir = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        docDir.append("/com.tetris.cache")
        if !FileManager.default.fileExists(atPath: docDir) {
            try? FileManager.default.createDirectory(atPath: docDir, withIntermediateDirectories: true, attributes: nil)
        }
        docDir.append("/\(version)")
        return docDir
    }
    
    class func construct(path: String) -> Bool {
        if let data = FileManager.default.contents(atPath: path) {
            let obj = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            if let obj = obj as? NSArray, obj.count > 0 {
                obj.enumerateObjects { (name, _, _) in
                    if let name = name as? String {
                        (NSClassFromString(name) as? TetrisStartable.Type)?.tetrisStart()
                    }
                }
                return true
            }
        }
        return false
    }
    
    class func starAwake() -> [String] {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        var classes = [String]()
        for index in 0 ..< typeCount {
            if let type = types[index] as? TetrisStartable.Type {
                classes.append(NSStringFromClass(types[index]))
                type.tetrisStart()
            }
        }
        types.deallocate()
        print("class count: \(classes.count)")
        return classes
    }
}
