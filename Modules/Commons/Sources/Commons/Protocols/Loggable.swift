import Foundation

public protocol Loggable {
    var logTag: String { get }
    func log(_ message: String, file: String, function: String, line: Int)
}

public extension Loggable {
    var logTag: String {
        "[\(String(describing: Self.self))]"
    }
    
    func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        Commons.log(message, tag: logTag, file: file, function: function, line: line)
    }
}

