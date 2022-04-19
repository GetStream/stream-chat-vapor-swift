import Vapor

struct SignInWithAppleToken: Content {
    let token: String
    let name: String?
    let username: String?
}
