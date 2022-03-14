import Fluent

extension User {
    struct CreateUser: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(v20220314.schemaName)
                .id()
                .field(v20220314.name, .string, .required)
                .field(v20220314.email, .string, .required)
                .field(v20220314.siwaID, .string)
                .create()
        }
        
        func revert(on database: Database) async throws {
            try await database.schema(v20220314.schemaName).delete()
        }
    }
}