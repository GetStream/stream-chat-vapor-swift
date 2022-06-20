import JWT
import Foundation

struct StreamPayload: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case expiration = "exp"
        case userID = "user_id"
    }

    /// The "exp" (expiration time) claim identifies the expiration time on
    /// or after which the JWT MUST NOT be accepted for processing.
    var expiration: ExpirationClaim?

    /// Custom data.
    /// If true, the user is an admin.
    var userID: String
    
    func verify(using signer: JWTSigner) throws {
        if let expiration = self.expiration {
            return try expiration.verifyNotExpired()
        }
    }
}
