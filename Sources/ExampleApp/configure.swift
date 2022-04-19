import Fluent
import FluentPostgresDriver
import Vapor
import StreamSDKVapor

// configures your application
public func configure(_ app: Application) throws {
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)

    // Run migrations
    try migrations(app)
    
    // register routes
    try routes(app)
    
    guard let streamAccessKey = Environment.get("STREAM_ACCESS_KEY"), let streamAccessSecret = Environment.get("STREAM_ACCESS_SECRET") else {
        app.logger.critical("STREAM keys not set")
        fatalError("STREAM keys not set")
    }
    
    let stream = Stream(accessKey: streamAccessKey, accessSecret: streamAccessSecret)
    app.stream.use(stream)
    
    app.middleware.use(app.sessions.middleware)
}
