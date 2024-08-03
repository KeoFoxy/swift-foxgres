import Fluent
import Foundation
import Vapor

final class Character: Model, @unchecked Sendable {
    static let schema = "characters"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "description")
    var description: String?

    @Field(key: "anime_id")
    var animeId: [UUID]
    
    @Field(key: "image_url")
    var imageUrl: String?
    
    init() {}

    init(
        id: UUID? = nil,
        name: String,
        description: String? = nil,
        animeId: [UUID],
        imageUrl: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.animeId = animeId
        self.imageUrl = imageUrl
    }
}
