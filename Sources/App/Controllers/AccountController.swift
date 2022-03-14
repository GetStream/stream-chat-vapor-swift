import Vapor

struct AccountController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let accountRoutes = routes.grouped(UserToken.authenticator(), User.guardMiddleware()).grouped("account")
        accountRoutes.get(use: getMeHandler)
    }
    
    func getMeHandler(_ req: Request) async throws -> User.Public {
        let user = try req.auth.require(User.self)
        return user.toPublic()
    }
}
