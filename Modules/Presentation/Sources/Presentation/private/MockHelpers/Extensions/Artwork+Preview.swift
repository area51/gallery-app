#if DEBUG
import Foundation
import AppCore

extension Artwork {
    init(id: Int, title: String, artist: String) {
        self.init(
            id: id,
            title: title,
            artistId: 666,
            artistTitle: artist,
            imageId: "e966799b-97ee-1cc6-bd2f-a94b4b8bb8f9"
        )
    }
    
    static func testData() -> [Artwork] {
        return [
            Artwork(id: 1, title: "Mona Lisa", artist: "Leonardo da Vinci"),
            Artwork(id: 2, title: "The Starry Night", artist: "Vincent van Gogh"),
            Artwork(id: 3, title: "The Last Supper", artist: "Leonardo da Vinci"),
            Artwork(id: 4, title: "The Scream", artist: "Edvard Munch"),
            Artwork(id: 5, title: "Guernica", artist: "Pablo Picasso"),
            Artwork(id: 6, title: "Girl with a Pearl Earring", artist: "Johannes Vermeer"),
            Artwork(id: 7, title: "The Persistence of Memory", artist: "Salvador Dalí"),
            Artwork(id: 8, title: "The Birth of Venus", artist: "Sandro Botticelli"),
            Artwork(id: 9, title: "The Creation of Adam", artist: "Michelangelo"),
            Artwork(id: 10, title: "Water Lilies", artist: "Claude Monet"),
            Artwork(id: 11, title: "The Starry Night Over the Rhône", artist: "Vincent van Gogh"),
            Artwork(id: 12, title: "The Thinker", artist: "Auguste Rodin"),
            Artwork(id: 13, title: "The School of Athens", artist: "Raphael"),
            Artwork(id: 14, title: "The Night Watch", artist: "Rembrandt"),
            Artwork(id: 15, title: "The Birth of Venus", artist: "Sandro Botticelli"),
            Artwork(id: 16, title: "Les Demoiselles d'Avignon", artist: "Pablo Picasso"),
            Artwork(id: 17, title: "The Great Wave off Kanagawa", artist: "Katsushika Hokusai"),
            Artwork(id: 18, title: "The Persistence of Memory", artist: "Salvador Dalí"),
            Artwork(id: 19, title: "The Kiss", artist: "Gustav Klimt"),
            Artwork(id: 20, title: "Campbell's Soup Cans", artist: "Andy Warhol")
        ]
    }
}
#endif
