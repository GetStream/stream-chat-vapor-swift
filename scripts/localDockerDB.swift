#!/usr/bin/swift
import Foundation

let databaseName = "vapor_database"
let username = "vapor_username"
let password = "vapor_password"
let port = 5432
let containerName = "stream-postgres"

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()

    return task.terminationStatus
}

let args = CommandLine.arguments

if args.contains("start") {
    start()
} else if args.contains("stop") {
    stop()
} else if args.contains("reset") {
    reset()
} else {
    print("Pass an argument, one of: [start, stop, reset]")
}

func start() {
    print("Starting local database in container \(containerName). \nDatabase name is \(databaseName), username is \(username) and password is \(password)")

    let dockerResult = shell("docker", "start", containerName)
    
    guard dockerResult == 0 else {
        print("Starting the Database failed, attempting to create one in Docker 🐳")
        create()
        exit(1)
    }
    
    print("Database started in Docker 🐳")
}

func create() {
    let dockerResult = shell("docker", "run", "--name", containerName, "-e",  "POSTGRES_DB=\(databaseName)", "-e", "POSTGRES_USER=\(username)" , "-e", "POSTGRES_PASSWORD=\(password)", "-p", "\(port):5432", "-d", "postgres")

    guard dockerResult == 0 else {
        print("❌ ERROR: Failed to create the database")
        exit(1)
    }

    print("Database created in Docker 🐳")
}

func stop() {
    let containerName = "stream-postgres"
    print("Stopping existing database in container \(containerName)")

    let stopResult = shell("docker", "stop", containerName)

    guard stopResult == 0 else {
        print("❌ ERROR: Failed to stop the database")
        exit(1)
    }
    
    print("Database stopped in Docker 🐳")
}

func reset() {
    shell("docker", "stop", containerName)
    let removeResult = shell("docker", "rm", containerName)

    guard removeResult == 0 else {
        print("❌ ERROR: Failed to remove the database container")
        exit(1)
    }
    
    print("Database destroyed in Docker 🐳")
}
