import Vapor

extension Application {
    public var stream: StreamWrapper {
        .init(application: self)
    }

    public struct StreamWrapper {
        public struct Provider {
            let run: (Application) -> ()

            public init(_ run: @escaping (Application) -> ()) {
                self.run = run
            }
        }
        
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
        
        public func use(_ stream: Stream) {
            self.storage.makeClient = { app in
                StreamClient(accessKey: stream.accessKey, accessSecret: stream.accessSecret, client: app.client, eventLoop: app.eventLoopGroup.next())
            }
        }

        public let application: Application
        
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

