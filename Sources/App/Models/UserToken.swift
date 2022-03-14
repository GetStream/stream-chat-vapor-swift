import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = v20220314.schemaName

    @ID
    var id: UUID?
    
    @Field(key: v20220314.value)
    var value: String

    @Parent(key: v20220314.userID)
    var user: User
    
    @Field(key: v20220314.expiration)
    var expiration: Date

    init() { }

    init(id: UUID? = nil, value: String, userID: User.IDValue, expiration: Date? = nil) {
        self.id = id
        self.value = value
        self.$user.id = userID
        if let expiration = expiration {
            self.expiration = expiration
        } else {
            // Expiration is 24 hours by default
            self.expiration = Date(timeIntervalSinceNow: 3600 * 24)
        }
    }
}

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        expiration > Date()
    }
}
