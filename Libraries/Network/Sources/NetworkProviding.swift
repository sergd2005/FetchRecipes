//
//  NetworkProviding.swift
//  NetworkProvider
//
//  Created by Sergii D on 2/18/25.
//

import Foundation

public protocol NetworkProviding: Sendable {
    func data(from url: URL, delegate: (any URLSessionTaskDelegate)? ) async throws -> (Data, URLResponse)
    func data(from url: URL) async throws -> (Data, URLResponse)
}
