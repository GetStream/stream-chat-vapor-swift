/// A `StreamConfiguration` contains the details necessary to configure the Stream SDK for your Vapor app
public struct StreamConfiguration {
    let accessKey: String
    let accessSecret: String
    
    /// Create an instance of `StreamConfiguration`
    /// - Parameters:
    ///   - accessKey: Your Stream App Access Key
    ///   - accessSecret: Your Stream App Access Secret
    public init(accessKey: String, accessSecret: String) {
        self.accessKey = accessKey
        self.accessSecret = accessSecret
    }
}
