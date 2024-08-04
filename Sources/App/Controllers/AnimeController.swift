import Vapor
import Fluent

struct AnimeController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let animes = routes.grouped("animes")
        
        animes.get(use: self.getAll)
        animes.get(":id", use: self.getById)
        animes.post(use: self.create)
        animes.put(":id", use: self.update)
        animes.delete(":id", use: self.delete)
    }
    
    @Sendable
    func getAll(req: Request) async throws -> [AnimeDTO] {
        let animes = try await Anime.query(on: req.db).all()
        return animes.map { AnimeDTO(from: $0) }
    }
    
    @Sendable
    func getById(req: Request) async throws -> AnimeDTO {
        guard let anime = try await Anime.find(req.parameters.get("id", as: UUID.self), on: req.db) else {
            throw Abort(.notFound)
        }
        
        return AnimeDTO(from: anime)
    }
    
    @Sendable
    func create(req: Request) async throws -> AnimeDTO {
        let anime = try req.content.decode(Anime.self)
        
        try await anime.save(on: req.db)
        return AnimeDTO(from: anime)
    }
    
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let animeID = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        guard let anime = try await Anime.find(animeID, on: req.db) else {
            throw Abort(.notFound)
        }
        try await anime.delete(on: req.db)
        return .noContent
    }
    
    @Sendable
    func update(req: Request) async throws -> AnimeDTO {
        guard let anime = try await Anime.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        let newAnime = try req.content.decode(Anime.self)
        anime.titleEn = newAnime.titleEn
        anime.titleJp = newAnime.titleJp
        anime.description = newAnime.description
        anime.releaseDate = newAnime.releaseDate
        anime.rating = newAnime.rating
        anime.episodeCount = newAnime.episodeCount
        anime.type = newAnime.type
        anime.characters = newAnime.characters
        anime.genres = newAnime.genres
        anime.imageUrl = newAnime.imageUrl
        
        try await anime.save(on: req.db)
        return AnimeDTO(from: anime)
    }
}
