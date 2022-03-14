import Vapor
import JWT
import Fluent

struct AuthController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let authRoutes = routes.grouped("auth")
        authRoutes.post("register", use: registerHandler)
        authRoutes.post("siwa", use: signInWithAppleHandler)
        
        let basicAuthRoutes = authRoutes.grouped(User.authenticator())
        basicAuthRoutes.post("login", use: loginHandler)
    }
    
    func registerHandler(_ req: Request) async throws -> UserToken {
        try CreateUserData.validate(content: req)
        
        let data = try req.content.decode(CreateUserData.self)
        let user = User(name: data.name, email: data.email, passwordHash: data.password, siwaID: nil)
        do {
            try await user.create(on: req.db)
        } catch {
            if let error = error as? DatabaseError, error.isConstraintFailure {
                throw Abort(.badRequest, reason: "A user with that email already exists")
            } else {
                throw error
            }
        }
        let token = try user.generateToken()
        try await token.create(on: req.db)
        return token
    }
    
    // Uses basic authentication to provide an actual bearer token
    func loginHandler(_ req: Request) async throws -> UserToken {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        try await token.create(on: req.db)
        return token
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
            // Set the password t oa secure random value. This won't be run through BCrypt so can't be used to log in anyway
            user = User(name: name, email: email, passwordHash: [UInt8].random(count: 32).base64, siwaID: siwaToken.subject.value)
            try await user.create(on: req.db)
        }
        let token = try user.generateToken()
        try await token.create(on: req.db)
        return token
    }
}

import Vapor

struct CreateUserData: Content, Validatable {
    var name: String
    var email: String
    var password: String
    
    /// Ensures a valid email is entered as well as a password of a given length (8 currently)
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("name", as: String.self, is: .count(1...))
    }
}