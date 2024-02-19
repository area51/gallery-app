import SwiftUI
import AppCore

struct ArtworkListItem: View {
    private let artwork: Artwork
    
    public init(artwork: Artwork) {
        self.artwork = artwork
    }
    
    var body: some View {
        HStack {
            AsyncArtImage(config: artworkConfig)
            VStack(alignment: .leading) {
                Text(artwork.title)
                if let artistTitle = artwork.artistTitle {
                    Text(artistTitle)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var artworkConfig: ArtworkPresentationConfig {
        ArtworkPresentationConfig.config(
            for: artwork,
            presentation: .thumbnail
        )
    }
}

#Preview {
    Group {
        Text("Artwork List Item")
        List {
            ArtworkListItem(artwork: Artwork.testData()[0])
        }
    }
}
