@testable import App
import Vapor
import XCTVapor
import Fluent

final class AnimeControllerTests: XCTestCase {
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
    
    func testGetAllAnimes() async throws {
        try await self.app.test(.GET, "animes", afterResponse: { res async in
            XCTAssertEqual(res.status, .ok)
            let responseAnimes = try? res.content.decode([AnimeDTO].self)
            XCTAssertEqual(responseAnimes?.count, 18)
        })
    }
    
    func testCreateAndGetAnimeById() async throws {
        let anime = AnimeDTO(id: UUID(), titleEn: "Test Anime", titleJp: "テストアニメ", description: "A test anime", releaseDate: Date(), rating: 9.0, episodeCount: 24, type: .tv, characters: [])

        try await self.app.test(.POST, "animes", beforeRequest: { req async in
            try? req.content.encode(anime)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
        })
        
        try await self.app.test(.GET, "animes/\(anime.id!)", afterResponse: { res async in
            XCTAssertEqual(res.status, .ok)
            
            do {
                let responseAnime = try res.content.decode(AnimeDTO.self)
                XCTAssertEqual(responseAnime.id, anime.id)
                XCTAssertEqual(responseAnime.titleEn, anime.titleEn)
                XCTAssertEqual(responseAnime.titleJp, anime.titleJp)
                XCTAssertEqual(responseAnime.description, anime.description)
                XCTAssertEqual(responseAnime.rating, anime.rating)
                XCTAssertEqual(responseAnime.episodeCount, anime.episodeCount)
                XCTAssertEqual(responseAnime.type, anime.type)
            } catch {
                XCTFail("Failed to decode response: \(error)")
            }
        })
    }

    
    func testCreateAnime() async throws {
        let newAnimeDTO = AnimeDTO(
            id: nil,
            titleEn: "Wotakoi: Love is Hard for Otaku",
            titleJp: "ヲタクに恋は難しい",
            description: "Description",
            releaseDate: Date(),
            rating: 9.0,
            episodeCount: 11,
            type: .tv,
            characters: [],
            genres: nil,
            imageUrl: "https://cdn.myanimelist.net/images/anime/1864/93518.jpg"
        )
        
        try await self.app.test(.POST, "animes", beforeRequest: { req async in
            try? req.content.encode(newAnimeDTO)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let responseAnime = try res.content.decode(AnimeDTO.self)
            XCTAssertEqual(responseAnime.titleEn, newAnimeDTO.titleEn)
            XCTAssertEqual(responseAnime.rating, newAnimeDTO.rating)
        })
    }
    
    func testUpdateAnime() async throws {
        let anime = Anime(titleEn: "Anime", titleJp: "アニメ", releaseDate: Date(), rating: 8.0, episodeCount: 12, type: .tv, characters: [])
        try await anime.create(on: app.db)
        
        let updatedAnimeDTO = AnimeDTO(id: anime.id, titleEn: "Updated Anime", titleJp: "更新されたアニメ", description: "Updated Description", releaseDate: Date(), rating: 9.0, episodeCount: 24, type: .tv, characters: [], genres: nil, imageUrl: nil)
        
        try await app.test(.PUT, "animes/\(anime.id!)", beforeRequest: { req async in
            try? req.content.encode(updatedAnimeDTO)
        }, afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let responseAnime = try res.content.decode(AnimeDTO.self)
            XCTAssertEqual(responseAnime.titleEn, updatedAnimeDTO.titleEn)
        })
    }
    
    func testDeleteAnime() async throws {
        let anime = Anime(id: UUID(), titleEn: "Anime", titleJp: "アニメ", releaseDate: Date(), rating: 8.0, episodeCount: 12, type: .tv, characters: [])
        try await anime.create(on: app.db)

        guard let savedAnime = try await Anime.find(anime.id, on: app.db) else {
            XCTFail("Anime not saved in the database")
            return
        }

        try await app.test(.DELETE, "animes/\(savedAnime.id!)", afterResponse: { res async in
            XCTAssertEqual(res.status, .noContent)
            let deletedAnime = try? await Anime.find(savedAnime.id, on: app.db)
            XCTAssertNil(deletedAnime)
        })
    }
}
