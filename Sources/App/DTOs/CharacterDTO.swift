import Vapor
import Foundation

struct CharacterDTO: Content {
    var id: UUID?
    var name: String
    var description: String?
    var animeId: [UUID]
    var imageUrl: String?
    
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
    
    init(from character: Character) {
        self.id = character.id
        self.name = character.name
        self.description = character.description
        self.animeId = character.animeId
        self.imageUrl = character.imageUrl
    }
}
