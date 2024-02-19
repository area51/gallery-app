import SwiftUI
import AppCore

struct AsyncArtImage: View {
    let imageConfig: ArtworkPresentationConfig
    
    init(config: ArtworkPresentationConfig) {
        self.imageConfig = config
    }
    
    var body: some View {
        Group {
            if let url = imageConfig.imageURL {
                AsyncImage(
                    url: url,
                    transaction: Transaction(animation: .easeInOut)
                ) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .transition(.scale(scale: 0.1, anchor: .center))
                    case .failure:
                        Image(systemName: "wifi.slash")
                            .font(.system(size: 40))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo.artframe")
                    .font(.system(size: 40))
            }
        }
        .frame(minWidth: imageConfig.minWidth)
        .frame(maxWidth: imageConfig.maxWidth)
        .frame(minHeight: imageConfig.minHeight)
        .frame(maxHeight: imageConfig.maxHeight)
        .background(imageConfig.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
    }
}
