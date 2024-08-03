import Foundation
import Vapor

struct AnimeDTO: Content {
    var id: UUID?
    var titleEn: String
    var titleJp: String
    var description: String?
    var releaseDate: Date
    var rating: Double
    var episodeCount: Int
    var type: AnimeType
    var characters: [UUID]
    var genres: [String]?
    var imageUrl: String?

    init(
        id: UUID? = nil,
        titleEn: String,
        titleJp: String,
        description: String? = nil,
        releaseDate: Date,
        rating: Double,
        episodeCount: Int,
        type: AnimeType,
        characters: [UUID],
        genres: [String]? = nil,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.titleEn = titleEn
        self.titleJp = titleJp
        self.description = description
        self.releaseDate = releaseDate
        self.rating = rating
        self.episodeCount = episodeCount
        self.type = type
        self.characters = characters
        self.genres = genres
        self.imageUrl = imageUrl
    }

    init(from anime: Anime) {
        id = anime.id
        titleEn = anime.titleEn
        titleJp = anime.titleJp
        description = anime.description
        releaseDate = anime.releaseDate
        rating = anime.rating
        episodeCount = anime.episodeCount
        type = anime.type
        characters = anime.characters
        genres = anime.genres
        imageUrl = anime.imageUrl
    }
}
