import Fluent

struct AddGenreAndImgUrlFields: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("animes")
            .field("genres", .array(of: .string))
            .field("image_url", .string)
            .update()
        
        try await database.schema("characters")
            .field("image_url", .string)
            .update()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("animes")
            .deleteField("genres")
            .deleteField("image_url")
            .update()
        
        try await database.schema("characters")
            .deleteField("image_url")
            .update()
    }
}
