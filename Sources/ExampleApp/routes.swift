import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get("hc") { req in
        "OK"
    }

    try app.register(collection: AuthController())
    try app.register(collection: AccountController())
}
