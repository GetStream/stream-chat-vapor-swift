import Vapor
import JWT
import Fluent

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let authRouthes = routes.grouped("auth")
        authRouthes.post("siwa", use: signInWithAppleHandler)
    }
    
    func signInWithAppleHandler(_ req: Request) async throws -> UserToken {
        let data = try req.content.decode(SignInWithAppleToken.self)
        guard let appIdentifier = Environment.get("IOS_APPLICATION_IDENTIFIER") else {
            throw Abort(.internalServerError)
        }
        let siwaToken = try await req.jwt.apple.verify(data.token, applicationIdentifier: appIdentifier)
        let user: User
        if let foundUser = try await User.query(on: req.db).filter(\.$siwaID == siwaToken.subject.value).first() {
            user = foundUser
        } else {
            guard let email = siwaToken.email, let name = data.name else {
                throw Abort(.badRequest)
            }
            user = User(name: name, email: email, siwaID: siwaToken.subject.value)
            try await user.create(on: req.db)
        }
        let token = try user.generateToken()
        try await token.create(on: req.db)
        return token
    }
}
