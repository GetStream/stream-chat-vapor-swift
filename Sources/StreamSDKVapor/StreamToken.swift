import Foundation

/// A type to hold a JWT to use with Stream SDKs
public struct StreamToken: Codable {
    /// The JWT to use with Stream SDKs
    public let jwt: String
}
