//
//  Dependencies.swift
//  NetworkProvider
//
//  Created by Sergii D on 2/17/25.
//
import Dependency

public extension Dependencies {
    var imageDownloader: any ImageDownloadProviding {
        get { Self[ImageDownloadDependencyProvider.self] }
    }
}

struct ImageDownloadDependencyProvider: DependencyProviding {
    nonisolated(unsafe) static var dependency: any ImageDownloadProviding = ImageDownloadProvider()
}
