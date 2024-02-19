import SwiftUI

/**
 A namespace for the colors used in the Gallery app.
 */

public extension Color {
    struct Gallery {
        public static let blue = Color(red: 4/255, green: 150/255, blue: 255/255)
        public static let cherry = Color(red: 255/255, green: 59/255, blue: 48/255)
        public static let offWhite = Color(red: 250/255, green: 249/255, blue: 246/255)
        
        public static let lightRed = cherry.opacity(0.7)
    }
}
