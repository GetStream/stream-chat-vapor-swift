import Vapor

struct LoginResponse: Content {
    let apiToken: UserToken
    let streamToken: String
}
