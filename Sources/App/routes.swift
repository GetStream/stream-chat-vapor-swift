import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get("hc") { req in
        "OK"
    }

}
