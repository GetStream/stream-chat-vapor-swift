import Vapor

extension Request {
    /// A `StreamClient` to use from the `Request`
    public var stream: StreamClient {
        self.application.stream.client.for(eventLoop: self.eventLoop, client: self.client)
    }
}
