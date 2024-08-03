import Fluent

struct CreateAnimeSchema: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("animes")
            .id()
            .field("title_en", .string, .required)
            .field("title_jp", .string, .required)
            .field("description", .string)
            .field("release_date", .date, .required)
            .field("rating", .double, .required)
            .field("episode_count", .int, .required)
            .field("type", .string, .required)
            .field("characters", .array(of: .uuid), .required)
            .create()
        
        try await database.schema("characters")
            .id()
            .field("name", .string, .required)
            .field("description", .string)
            .field("anime_id", .array(of: .uuid), .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("animes").delete()
        try await database.schema("characters").delete()
    }
}
