import Foundation
import JWTKit
import Vapor

public struct StreamClient {
    let accessKey: String
    let accessSecret: String
    let client: Client
    let eventLoop: EventLoop
    
    func `for`(eventLoop: EventLoop, client: Client) -> StreamClient {
        StreamClient(accessKey: self.accessKey, accessSecret: self.accessSecret, client: client, eventLoop: eventLoop)
    }
    
    public init(accessKey: String, accessSecret: String, client: Client, eventLoop: EventLoop) {
        self.accessKey = accessKey
        self.accessSecret = accessSecret
        self.client = client
        self.eventLoop = eventLoop
    }
    
    public func createToken(name: String, expiresAt: Date? = nil) throws -> StreamToken {
        let signer = JWTSigner.hs256(key: accessSecret)
        let expiration: ExpirationClaim?
        if let expiresAt = expiresAt {
            expiration = .init(value: expiresAt)
        } else {
            expiration = nil
        }
        let payload = StreamPayload(
            expiration: expiration,
            userID: name
        )
        let jwt = try signer.sign(payload)
        return StreamToken(jwt: jwt)
    }
}


public struct StreamToken: Codable {
    public let jwt: String
}

public struct StreamPayload: JWTPayload {
    enum CodingKeys: String, CodingKey {
        case expiration = "exp"
        case userID = "user_id"
    }

    // The "exp" (expiration time) claim identifies the expiration time on
    // or after which the JWT MUST NOT be accepted for processing.
    var expiration: ExpirationClaim?

    // Custom data.
    // If true, the user is an admin.
    var userID: String
    
    public func verify(using signer: JWTSigner) throws {
        if let expiration = self.expiration {
            return try expiration.verifyNotExpired()
        }
    }
}
