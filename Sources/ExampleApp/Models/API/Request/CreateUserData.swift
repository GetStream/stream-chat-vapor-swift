import Vapor

struct CreateUserData: Content, Validatable {
    var name: String
    var email: String
    var password: String
    var username: String
    
    /// Ensures a valid email is entered as well as a password of a given length (8 currently)
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
        validations.add("name", as: String.self, is: .count(1...))
        validations.add("username", as: String.self, is: .alphanumeric && .count(3...))
    }
}
