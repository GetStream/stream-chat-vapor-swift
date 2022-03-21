import Vapor

extension Request {
    public var stream: StreamClient {
        self.application.stream.client.for(eventLoop: self.eventLoop, client: self.client)
    }
}
