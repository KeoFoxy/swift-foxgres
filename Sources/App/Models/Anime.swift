import Fluent
import Foundation
import Vapor

final class Anime: Model, @unchecked Sendable {
    static let schema: String = "animes"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title_en")
    var titleEn: String
    
    @Field(key: "title_jp")
    var titleJp: String
    
    @Field(key: "description")
    var description: String?
    
    @Field(key: "release_date")
    var releaseDate: Date
    
    @Field(key: "rating")
    var rating: Double
    
    @Field(key: "episode_count")
    var episodeCount: Int
    
    @Field(key: "type")
    var type: AnimeType
    
    @Field(key: "characters")
    var characters: [UUID]
    
    @Field(key: "genres")
    var genres: [String]?
    
    @Field(key: "image_url")
    var imageUrl: String?
    
    init() {}
    
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
}


enum AnimeType: String, Content {
    case tv = "TV"
    case film = "Film"
    case ova = "OVA"
}
