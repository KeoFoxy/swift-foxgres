import Fluent
import FluentPostgresDriver
import Leaf
import NIOSSL
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    
    try app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "admin",
        password: Environment.get("DATABASE_PASSWORD") ?? "admin",
        database: Environment.get("DATABASE_NAME") ?? "foxgres",
        tls: .prefer(.init(configuration: .clientDefault))
    )
    ), as: .psql)

    app.migrations.add(CreateAnimeSchema())
    app.migrations.add(AddGenreAndImgUrlFields())
    app.migrations.add(FillDatabase())

    app.views.use(.leaf)
    // Disable CORS
    app.middleware.use(configureCORS())

    // register routes
    try routes(app)
}
