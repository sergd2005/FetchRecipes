// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public protocol NetworkProviding: Sendable {
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)? ) async throws -> (Data, URLResponse)
    func data(from url: URL) async throws -> (Data, URLResponse)
}

public final class NetworkProvider: NetworkProviding {
    public init() {}
    
    public func data(from url: URL, delegate: (any URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        try await URLSession.shared.data(from: url, delegate: delegate)
    }
    
    public func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(from: url)
    }
}

