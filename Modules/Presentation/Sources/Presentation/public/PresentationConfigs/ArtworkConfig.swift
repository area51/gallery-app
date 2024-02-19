import SwiftUI
import AppCore

public struct ArtworkPresentationConfig {
    public let imageURL: URL?
    public let originalWidth: CGFloat?
    
    public var minWidth: CGFloat?
    public var maxWidth: CGFloat?
    
    public var minHeight: CGFloat?
    public var maxHeight: CGFloat?
    
    public var backgroundColor: Color
    
    public init(
        imageURL: URL?,
        originalWidth: CGFloat?,
        minWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil,
        backgroundColor: Color = .clear
    ) {
        self.imageURL = imageURL
        self.originalWidth = originalWidth
        self.minWidth = minWidth
        self.maxWidth = maxWidth
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.backgroundColor = backgroundColor
    }
    
    /// Builds the configuration of the image presentation.
    /// - parameter artwork: The artwork to be presented.
    /// - parameter presentation: The desired presentation.
    /// - returns: The configuration of the image presentation.
    static public func config(
        for artwork: Artwork,
        presentation: Presentation
    ) -> ArtworkPresentationConfig {
        let width = String(describing: Int(presentation.rawValue))
        var imageURL: URL?
        if let id = artwork.imageId {
            imageURL = ImageURLFactory.make(for: id, width: width)
        }
        return ArtworkPresentationConfig(
            imageURL: imageURL,
            originalWidth: presentation.rawValue,
            minWidth: presentation.minWidth,
            maxWidth: presentation.maxWidth,
            minHeight: presentation.minHeight,
            maxHeight: presentation.maxHeight,
            backgroundColor: presentation.backgroundColor
        )
    }
}


extension ArtworkPresentationConfig {
    /// Available widths of the image.
    public enum Presentation: CGFloat {
        case thumbnail = 200
        case normal = 843
        
        public var minWidth: CGFloat {
            switch self {
                case .thumbnail:
                    return 100
                case .normal:
                    return 200
            }
        }
        
        public var maxWidth: CGFloat {
            switch self {
                case .thumbnail:
                    return 100
                case .normal:
                    return 200 * 2
            }
        }
        
        public var minHeight: CGFloat {
            switch self {
                case .thumbnail:
                    return 100
                case .normal:
                    return 200
            }
        }
        
        public var maxHeight: CGFloat {
            switch self {
                case .thumbnail:
                    return 100
                case .normal:
                    return 200 * 2
            }
        }
        
        public var backgroundColor: Color {
            switch self {
                case .thumbnail:
                return .gray.opacity(0.1)
                case .normal:
                    return .clear
            }
        }
    }
}
