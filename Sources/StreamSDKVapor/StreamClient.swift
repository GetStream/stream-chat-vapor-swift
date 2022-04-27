import Foundation
import JWTKit
import Vapor


/// A client for interacting with Stream and their services
public struct StreamClient {
    let accessKey: String
    let accessSecret: String
    let client: Client
    let eventLoop: EventLoop
    
    func `for`(eventLoop: EventLoop, client: Client) -> StreamClient {
        StreamClient(accessKey: self.accessKey, accessSecret: self.accessSecret, client: client, eventLoop: eventLoop)
    }
    
    
    init(accessKey: String, accessSecret: String, client: Client, eventLoop: EventLoop) {
        self.accessKey = accessKey
        self.accessSecret = accessSecret
        self.client = client
        self.eventLoop = eventLoop
    }
    
    
    /// Create a JWT to use with client SDKs to interact with Stream
    /// - Parameters:
    ///   - id: The ID of the user for the token
    ///   - expiresAt: An optional date the token should expire at. Defaults to no expiry date
    /// - Returns: A `StreamToken` containing the JWT to provide to client SDKs
    public func createToken(id: String, expiresAt: Date? = nil) throws -> StreamToken {
        let signer = JWTSigner.hs256(key: accessSecret)
        let expiration: ExpirationClaim?
        if let expiresAt = expiresAt {
            expiration = .init(value: expiresAt)
        } else {
            expiration = nil
        }
        let payload = StreamPayload(
            expiration: expiration,
            userID: id
        )
        let jwt = try signer.sign(payload)
        return StreamToken(jwt: jwt)
    }
}
