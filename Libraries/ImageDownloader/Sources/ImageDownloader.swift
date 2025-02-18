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

public protocol ImageDownloadProviding {
    func downloadImage(from url: URL, for delegate: ImageDownloadProvidingDelegate) async
}

public actor ImageDownloadProvider: ImageDownloadProviding {
    @Dependency(\.networkProvider) var networkProvider: any NetworkProviding
    
    var tasks = [URL: Task<Void, Never>]()
    
    public func downloadImage(from url: URL, for delegate: ImageDownloadProvidingDelegate) async {
        guard tasks[url] == nil else { return }
        let task = Task {
            defer {
                tasks[url] = nil
            }
            do {
                let (imageData, response) = try await networkProvider.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else { throw ImageDownloadProvidingError.badHttpResponse }
                guard let image = UIImage(data: imageData) else { throw ImageDownloadProvidingError.badImageData }
                await delegate.imageDownloadComplete(result: .success(image))
            } catch(let error) {
                await delegate.imageDownloadComplete(result: .failure(error))
            }
        }
        tasks[url] = task
    }
}
