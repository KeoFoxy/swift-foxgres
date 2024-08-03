import Vapor
import Fluent

struct CharacterController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let characters = routes.grouped("characters")
        
        characters.get(use: self.getAll)
        characters.get(":id", use: self.getById)
        characters.post(use: self.create)
        characters.put(":id", use: self.update)
        characters.delete(":id", use: self.delete)
    }

    @Sendable
    func getAll(req: Request) async throws -> [CharacterDTO] {
        let characters = try await Character.query(on: req.db).all()
        return characters.map { CharacterDTO(from: $0) }
    }
    
    @Sendable
    func getById(req: Request) async throws -> CharacterDTO {
        guard let character = try await Character.find(req.parameters.get("id", as: UUID.self), on: req.db) else {
            throw Abort(.notFound)
        }

        return CharacterDTO(from: character)
    }

    @Sendable
    func create(req: Request) async throws -> CharacterDTO {
        let character = try req.content.decode(Character.self)

        try await character.save(on: req.db)
        return CharacterDTO(from: character)
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let character = try await Character.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await character.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> CharacterDTO {
        guard let character = try await Character.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        let newCharacter = try req.content.decode(Character.self)
        character.name = newCharacter.name
        character.description = newCharacter.description
        character.animeId = newCharacter.animeId
        character.imageUrl = newCharacter.imageUrl

        try await character.save(on: req.db)
        return CharacterDTO(from: character)
    }
}
