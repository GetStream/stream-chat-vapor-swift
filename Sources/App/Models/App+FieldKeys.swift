import Fluent

extension User {
    enum v20220314 {
        static let schemaName = "users"
        static let id = FieldKey(stringLiteral: "id")
        static let name = FieldKey(stringLiteral: "name")
        static let siwaID = FieldKey(stringLiteral: "sign_in_with_apple_id")
        static let email = FieldKey(stringLiteral: "email")
    }
}

extension UserToken {
    enum v20220314 {
        static let schemaName = "user_tokens"
        static let id = FieldKey(stringLiteral: "id")
        static let value = FieldKey(stringLiteral: "value")
        static let userID = FieldKey(stringLiteral: "user_id")
        static let expiration = FieldKey(stringLiteral: "expiration")
    }
}