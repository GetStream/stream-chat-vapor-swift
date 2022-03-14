import Vapor
import Fluent

final class User: Model, Content {
    static let schema = v20220314.schemaName
    
    @ID
    var id: UUID?
    
    @Field(key: v20220314.name)
    var name: String
    
    @Field(key: v20220314.email)
    var email: String
    
    @Field(key: v20220314.email)
    var username: String
    
    @Field(key: v20220314.passwordHash)
    var passwordHash: String
    
    @Field(key: v20220314.siwaID)
    var siwaID: String?

    init() { }
    
    init(id: UUID? = nil, name: String, email: String, username: String, passwordHash: String, siwaID: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.username = username
        self.passwordHash = passwordHash
        self.siwaID = siwaID
    }
}

extension User: ModelAuthenticatable {
    static let passwordHashKey = \User.$passwordHash
    static var usernameKey = \User.$email
    
    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User: ModelSessionAuthenticatable {}

extension User {
    func generateToken() throws -> UserToken {
        try UserToken(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}
