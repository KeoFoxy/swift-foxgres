@testable import App
import Vapor
import XCTVapor
import Fluent

final class CharacterControllerTests: XCTestCase {
    var app: Application!
    
    override func setUp() async throws {
        self.app = try await Application.make(.testing)
        try await configure(app)
        try await app.autoMigrate()
    }
    
    override func tearDown() async throws {
        try await app.autoRevert()
        try await self.app.asyncShutdown()
        self.app = nil
    }
    
    func testGetAllCharacters() async throws {
        try await self.app.test(.GET, "characters", afterResponse: { res async in
            XCTAssertEqual(res.status, .ok)
            let responseCharacters = try? res.content.decode([CharacterDTO].self)
            XCTAssertEqual(responseCharacters?.count, 17)
        })
    }
    
    func testCreateAndGetCharacterById() async throws {
        let character = CharacterDTO(id: UUID(), name: "Test Character", description: "A test character", animeId: [UUID()], imageUrl: "https://example.com/image.jpg")

        try await self.app.test(.POST, "characters", beforeRequest: { req async in
            try? req.content.encode(character)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        try await self.app.test(.GET, "characters/\(character.id!)", afterResponse: { res async in
            XCTAssertEqual(res.status, .ok)
            
            do {
                let responseCharacter = try res.content.decode(CharacterDTO.self)
                XCTAssertEqual(responseCharacter.id, character.id)
                XCTAssertEqual(responseCharacter.name, character.name)
                XCTAssertEqual(responseCharacter.description, character.description)
                XCTAssertEqual(responseCharacter.animeId, character.animeId)
                XCTAssertEqual(responseCharacter.imageUrl, character.imageUrl)
            } catch {
                XCTFail("Failed to decode response: \(error)")
            }
        })
    }

    
    func testCreateCharacter() async throws {
        let newCharacterDTO = CharacterDTO(
            id: nil,
            name: "Naruto Uzumaki",
            description: "Main character of Naruto",
            animeId: [UUID()],
            imageUrl: "https://example.com/naruto.jpg"
        )
        
        try await self.app.test(.POST, "characters", beforeRequest: { req async in
            try? req.content.encode(newCharacterDTO)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let responseCharacter = try res.content.decode(CharacterDTO.self)
            XCTAssertEqual(responseCharacter.name, newCharacterDTO.name)
            XCTAssertEqual(responseCharacter.description, newCharacterDTO.description)
            XCTAssertEqual(responseCharacter.imageUrl, newCharacterDTO.imageUrl)
        })
    }
    
    func testUpdateCharacter() async throws {
        let character = Character(name: "Character", description: "Description", animeId: [UUID()], imageUrl: "https://example.com/image.jpg")
        try await character.create(on: app.db)
        
        let updatedCharacterDTO = CharacterDTO(id: character.id, name: "Updated Character", description: "Updated Description", animeId: character.animeId, imageUrl: "https://example.com/updated_image.jpg")
        
        try await app.test(.PUT, "characters/\(character.id!)", beforeRequest: { req async in
            try? req.content.encode(updatedCharacterDTO)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let responseCharacter = try res.content.decode(CharacterDTO.self)
            XCTAssertEqual(responseCharacter.name, updatedCharacterDTO.name)
            XCTAssertEqual(responseCharacter.description, updatedCharacterDTO.description)
            XCTAssertEqual(responseCharacter.imageUrl, updatedCharacterDTO.imageUrl)
        })
    }
    
    func testDeleteCharacter() async throws {
        let character = Character(id: UUID(), name: "Character", description: "Description", animeId: [UUID()], imageUrl: "https://example.com/image.jpg")
        try await character.create(on: app.db)

        guard let savedCharacter = try await Character.find(character.id, on: app.db) else {
            XCTFail("Character not saved in the database")
            return
        }

        try await app.test(.DELETE, "characters/\(savedCharacter.id!)", afterResponse: { res async in
            XCTAssertEqual(res.status, .noContent)
            let deletedCharacter = try? await Character.find(savedCharacter.id, on: app.db)
            XCTAssertNil(deletedCharacter)
        })
    }
}
