import Vapor

extension Application {
    
    /// The `StreamWrapper` to allow the Stream SDK to be integrated with Vapor
    public var stream: StreamWrapper {
        .init(application: self)
    }

    
    /// A wrapper class containing everything needed to make integrating with Vapor seamless
    public struct StreamWrapper {
        /// The `StreamClient` used for generating JWTs etc
        public var client: StreamClient {
            guard let makeClient = self.storage.makeClient else {
                fatalError("No stream configured. Configure with app.clients.use(...)")
            }
            return makeClient(self.application)
        }
        
        final class Storage {
            var makeClient: ((Application) -> StreamClient)?
            init() { }
        }
        
        struct Key: StorageKey {
            typealias Value = Storage
        }

        func initialize() {
            self.application.storage[Key.self] = .init()
        }
        
        
        /// Tell Vapor what configuration to use for the `StreamClient`
        /// - Parameter config: the config to use
        public func use(_ config: StreamConfiguration) {
            self.storage.makeClient = { app in
                StreamClient(accessKey: config.accessKey, accessSecret: config.accessSecret, client: app.client, eventLoop: app.eventLoopGroup.next())
            }
        }

        let application: Application
        
        var storage: Storage {
            guard let storage = self.application.storage[Key.self] else {
                let storage = Storage()
                self.application.storage[Key.self] = storage
                return storage
            }
            return storage
        }
    }
}

