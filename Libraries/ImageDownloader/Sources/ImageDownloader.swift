// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation
import UIKit
import Dependency
import NetworkProvider

public protocol ImageDownloadProvidingDelegate: Sendable {
    func imageDownloadComplete(result: Result<UIImage, Error>) async
}

public enum ImageDownloadProvidingError: Error {
    case badHttpResponse
    case badImageData
}

public protocol ImageDownloadProviding: Sendable {
    func downloadImage(from url: URL) async -> Task<UIImage, Error>
}

public actor ImageDownloadProvider: ImageDownloadProviding {
    @Dependency(\.networkProvider) var networkProvider: any NetworkProviding
    
    var tasks = [URL: Task<UIImage, Error>]()
    
    public func downloadImage(from url: URL) async -> Task<UIImage, Error> {
        guard tasks[url] == nil else { return tasks[url]! }
        let task = Task {
            defer {
                tasks[url] = nil
            }
            let (imageData, response) = try await networkProvider.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { throw ImageDownloadProvidingError.badHttpResponse }
            guard let image = UIImage(data: imageData) else { throw ImageDownloadProvidingError.badImageData }
            return image
        }
        tasks[url] = task
        return task
    }
}
