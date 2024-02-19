import Foundation

public struct ImageURLFactory {
    
    /// Builds the URL of the image with the given size.
    /// - parameter id: The unique identifier of the image.
    /// - parameter width: The width of the image.
    /// - returns: The URL of the image with the given size.
    static public func make(for id: String, width: String) -> URL? {
        let templateURL = "https://www.artic.edu/iiif/2/{identifier}/full/{size},/0/default.jpg"
        let absolutURL = templateURL
            .replacingOccurrences(of: "{identifier}", with: id)
            .replacingOccurrences(of: "{size}", with: width)
        return URL(string: absolutURL)
    }
}
