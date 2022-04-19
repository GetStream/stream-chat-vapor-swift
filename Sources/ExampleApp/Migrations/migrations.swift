import Fluent
import Vapor

func migrations(_ app: Application) throws {
    app.migrations.add(User.CreateUser())
    app.migrations.add(UserToken.CreaetUserToken())
    
    try app.autoMigrate().wait()
}
