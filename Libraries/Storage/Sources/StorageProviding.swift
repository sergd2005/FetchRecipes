// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol StorageProviding: Sendable {
    func save(data: Data, with id: String) async throws
    func readData(with id: String) async -> Data?
}
