//
//  Dependencies.swift
//  NetworkProvider
//
//  Created by Sergii D on 2/17/25.
//
import Dependency

public extension Dependencies {
    var networkProvider: any NetworkProviding {
        get { Self[NetworkDependencyProvider.self] }
    }
}

struct NetworkDependencyProvider: DependencyProviding {
    nonisolated(unsafe) static var dependency: any NetworkProviding = NetworkProvider()
}
