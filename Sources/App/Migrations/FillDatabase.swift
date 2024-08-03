import Vapor
import Fluent
import Foundation

struct FillDatabase: AsyncMigration {
    func prepare(on database: Database) async throws {
        let logger = Logger(label: "FillDatabase")


        let currentUrl = FileManager.default.currentDirectoryPath
        let animeFileURL = URL(fileURLWithPath: currentUrl.appending("/Resources/data/anime_data.json"))
        let charactersFileURL = URL(fileURLWithPath: currentUrl.appending("/Resources/data/characters_data.json"))
        
        print("\n\n\nDEBUG: AnimeURL - \(animeFileURL)")
        print("\nDEBUG: CharactersURL - \(charactersFileURL)")
        print("\n\n\n")
        
        do {
            let animeData = try Data(contentsOf: animeFileURL)
            let characterData = try Data(contentsOf: charactersFileURL)

            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let animeJSONString = String(data: animeData, encoding: .utf8) {
                logger.info("Anime JSON: \(animeJSONString)")
            } else {
                logger.error("Failed to convert animeData to String")
            }

            if let characterJSONString = String(data: characterData, encoding: .utf8) {
                logger.info("Character JSON: \(characterJSONString)")
            } else {
                logger.error("Failed to convert characterData to String")
            }

            let animes = try decoder.decode([Anime].self, from: animeData)
            let characters = try decoder.decode([Character].self, from: characterData)
            
            logger.info("Successfully decoded anime and character data")
            logger.info("Anime count: \(animes.count)")
            logger.info("Character count: \(characters.count)")
            
            for anime in animes {
                try await anime.create(on: database)
                logger.info("Inserted anime: \(anime.titleEn)")
            }

            for character in characters {
                try await character.create(on: database)
                logger.info("Inserted character: \(character.name)")
            }
        } catch {
            logger.error("Error loading or decoding data: \(error)")
            throw error
        }
    }
    
    func revert(on database: Database) async throws {
        try await Character.query(on: database).delete()
        try await Anime.query(on: database).delete()
    }
}
