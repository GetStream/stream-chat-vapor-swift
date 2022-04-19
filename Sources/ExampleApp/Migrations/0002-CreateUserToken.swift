import Fluent

extension UserToken {
    struct CreaetUserToken: AsyncMigration {
        func prepare(on database: Database) async throws {
            try await database.schema(v20220314.schemaName)
                .id()
                .field(v20220314.value, .string, .required)
                .field(v20220314.userID, .uuid, .required, .references(User.v20220314.schemaName, User.v20220314.id))
                .field(v20220314.expiration, .datetime, .required)
                .unique(on: v20220314.value)
                .create()
        }

        func revert(on database: Database) async throws {
            try await database.schema(v20220314.schemaName).delete()
        }
    }
}
