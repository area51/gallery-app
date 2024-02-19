import Foundation

public func log(
    _ message: String,
    tag: String? = nil,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    #if DEBUG
    let fileName = file.components(separatedBy: "/").last ?? ""
    if let tag = tag {
        print("\(tag) \(fileName):\(line) \(function) \(message)")
    } else {
        print("\(fileName):\(line) \(function) \(message)")
    }
    #endif
}
